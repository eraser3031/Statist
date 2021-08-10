//
//  TodoView.swift
//  Statist
//
//  Created by Kimyaehoon on 06/08/2021.
//

import SwiftUI
import Introspect

struct TodoView: View {
    
    @StateObject var vm: TodoViewModel
    @Namespace private var namespace
    
    init(date: Date){
        self._vm = StateObject(wrappedValue: TodoViewModel())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.vertical, 20)
            
            GroupedCalendarView(info: $vm.calendarInfo)
                .shadow(color: Color.theme.shadowColor.opacity(0.14), radius: 14, x: 0.0, y: 8)
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24){
                    if vm.entitysGroupedByKind.isEmpty {
                        empty
                    } else {
                        todoList
                        
                        Text("") // For Offset ( TodoItemTask
                            .font(Font.system(.subheadline, design: .default).weight(.semibold))
                            .padding(16 + 20)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .overlay(curtain.ignoresSafeArea(.keyboard, edges: .bottom))
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
            
            VStack(alignment: .leading, spacing: 10){
                HStack(spacing: 8) {
                    Circle()
                        .fill(primaryColor)
                        .frame(width: 12, height: 12)
                    
                    Text(name)
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                }
                .padding(.vertical, 10)
                
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
            .frame(height: 300)
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
                            removal: .opacity.animation(.easeIn(duration: 0.05))
                        )
                    )
                    .padding(.vertical, 20)
            }
            
            
            HStack(spacing: 8) {
                customTextField
                    .animation(.spring())
                
                if vm.canTask {
                    submitTaskButton
                        .transition(.scale.animation(.easeIn(duration: 0.2)))
                }
                
            }
            .transition(.scale.animation(.spring()))
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Color.primary.opacity(0.01))
    }
    
    private var curtain: some View {
        Group {
            if vm.taskCase != .none {
                ZStack {
                    Color.primary
                        .opacity(0.1)
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
                vm.addTodoEntity()
                vm.clearTask()
            case .edit:
                vm.editTodoEntity()
                vm.clearTask()
            case .none:
                print("error: impossible state of taskCase in onCommit")
                vm.clearTask()
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
                    vm.addTodoEntity()
                    vm.clearTask()
                }
            case .edit:
                if vm.canTask {
                    vm.editTodoEntity()
                    vm.clearTask()
                }
            case .none:
                print("error: impossible state of taskCase in onCommit")
            }
        }
        .introspectTextField(customize: { textField in
            //            textField.returnKeyType = .done
            if vm.taskCase == .edit {
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
