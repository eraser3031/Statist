//
//  TodoView.swift
//  Statist
//
//  Created by Kimyaehoon on 06/08/2021.
//

import SwiftUI
import Introspect

struct TodoView: View {
    
    @StateObject var vm = TodoViewModel()
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.vertical, 20)
            
            GroupedCalendarView(info: $vm.calendarInfo, dates: vm.todoEvents?.dates ?? [])
                .shadow(color: Color.theme.shadowColor.opacity(0.1), radius: 12, x: 0.0, y: 5)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            
            if vm.entitysGroupedByKind.isEmpty {
                VStack(spacing: 24) {
                    empty
                    
                    Text("") // For Offset ( TodoItemTask
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                        .padding(16 + 14)
                }
                .padding(.horizontal, 16)
                .transition(AnyTransition.asymmetric(insertion: .move(edge: .bottom), removal: .opacity.animation(.easeInOut(duration: 0.1))))
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 28){
                        todoList
                        
                        Text("") // For Offset ( TodoItemTask
                            .font(Font.system(.subheadline, design: .default).weight(.semibold))
                            .padding(16 + 20)
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .scaleEffect(vm.taskCase == .none ? 1 : 0.96)
        .overlay(curtain)
        .ignoresSafeArea(.keyboard)
        .overlay(
            todoItemTask
            ,alignment: .bottom
        )
        .onChange(of: vm.calendarInfo.date) { _ in
            withAnimation(.spring()){
                vm.entitys()
            }
        }
    }
    
    //  MARK: - Components
    
    private var todoList: some View {
        ForEach(vm.entitysGroupedByKind, id: \.id) { groupedByKind in
            
            let entitys = groupedByKind.entitys
            let kind = groupedByKind.kindEntity
            let name = kind.name ?? ""
            let primaryColor = kind.color.toPrimary()
            
            VStack(alignment: .leading, spacing: 0){
                HStack(spacing: 8) {
                    Circle()
                        .fill(primaryColor)
                        .frame(width: 10, height: 10)
                    
                    Text(name)
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                }
                .padding(.vertical, 12)
                
                VStack(spacing: 12) {
                    ForEach(entitys) { entity in
                        NewTodoItemView(entity, vm: vm)
                    }
                }
            }
            
        }
    }
    
    private var header: some View {
        HStack(spacing: 0){
            Text("Todo")
                .font(.title2).bold()
            
            Spacer()
            
            Circle()
                .frame(width: 32, height: 32)
        }
        .padding(.horizontal, 20)
    }
    
    private var empty: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.theme.subBackgroundColor)
//            .frame(height: 300)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.theme.dividerColor,
                            style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [8]))
                    .padding(1)
            )
            .overlay(
                VStack(spacing: 4) {
                Image(systemName: "moon.zzz.fill")
                    .font(.title2)
                
                Text("Todo is empty")
                    .font(.footnote)
            }
                    .foregroundColor(.secondary)
            )
    }
    
    private var todoItemTask: some View {
        VStack(spacing: 0) {
            
            if vm.taskCase != .none {
                KindPicker($vm.kind, showKindView: $vm.showKindView, kinds: vm.kinds)
                    .contentShape(Rectangle())
                    .transition(
                        AnyTransition.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .bottom)),
                            removal: .opacity.animation(.easeIn(duration: 0.1))
                        )
                    )
                    .padding(.vertical, 20)
                    .sheet(isPresented: $vm.showKindView, onDismiss: {
                        withAnimation(.spring()) {
                            vm.entitys()
                            vm.kindEntitys()
                        }
                    }) {
                        KindView()
                    }
            }
            
            
            HStack(spacing: 8) {
                customTextField
                    .animation(.spring())
                    .compositingGroup()
                    .shadow(color: Color.theme.shadowColor.opacity(0.2), radius: 20, x: 0.0, y: 10)
                
                if vm.canTask {
                    submitTaskButton
                        .transition(
                            AnyTransition.asymmetric(insertion: .scale.animation(.spring()),
                                                     removal: .opacity.animation(.easeIn(duration: 0.1)))
                        )
                }
                
            }
            .transition(.scale.animation(.spring()))
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Color(.systemBackground).opacity(0.01))
    }
    
    private var curtain: some View {
        Group {
            if vm.taskCase != .none {
                ZStack {
                    Color.black
                        .opacity(0.2)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                vm.clearTask()
                            }
                        }
                }
            }
        }
    }
    
    private var submitTaskButton: some View {
        Button(action: {
            switch vm.taskCase {
            case .add:
                withAnimation(.spring()) {
                    vm.addTodoEntity()
                    vm.clearTask()
                }

            case .edit:
                withAnimation(.spring()) {
                    vm.editTodoEntity()
                    vm.clearTask()
                }
                
            case .none:
                print("error: impossible state of taskCase in onCommit")
                withAnimation(.spring()) {
                    vm.clearTask()
                }
            }
        }) {
            Circle()
                .fill(Color.primary)
                .overlay(
                    Image(systemName: vm.taskCase == .edit ? "pencil" : "plus")
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                        .foregroundColor(Color(.systemBackground))
                )
                .frame(width: 48, height: 48)
                .disabled(!vm.canTask)
        }
    }
    
    private var customTextField: some View {
        TextField("Add new Todo", text: $vm.text) { isEdit in
            if isEdit && vm.taskCase == .none {
                withAnimation(.easeInOut) {
                    vm.taskCase = .add
                }
            }
        } onCommit: {
            switch vm.taskCase {
            case .add:
                if vm.canTask {
                    withAnimation(.spring()){
                        vm.addTodoEntity()
                        vm.clearTask()
                    }
                }
            case .edit:
                if vm.canTask {
                    withAnimation(.spring()){                    
                        vm.editTodoEntity()
                        vm.clearTask()
                    }
                }
            case .none:
                print("error: impossible state of taskCase in onCommit")
            }
        }
        .introspectTextField(customize: { textField in
            //            textField.returnKeyType = .done
            if vm.taskCase == .edit && vm.showKindView == false {
                textField.becomeFirstResponder()
            }
        })
        .disableAutocorrection(true)
        .overlay(
            Image(systemName: "xmark.circle.fill")
                .padding()
                .offset(x: 10)
                .foregroundColor(.secondary)
                .opacity(vm.text.isEmpty ? 0.0 : 1.0)
                .onTapGesture {
            vm.text = ""
        }
            , alignment: .trailing
        )
        .font(Font.system(.subheadline, design: .default).weight(.semibold))
        .padding(16)
        .frame(maxWidth: 400, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.theme.dividerColor)
        )
    }
}
