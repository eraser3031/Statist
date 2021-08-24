//
//  TodoView.swift
//  Statist
//
//  Created by Kimyaehoon on 06/08/2021.
//

import SwiftUI
import Introspect

struct TodoView: View {
    @Environment(\.horizontalSizeClass) var horizontalSize
    @StateObject var vm = TodoViewModel()
    @Namespace private var namespace
    let show: () -> Void
    
    let defaultAnimation = Animation.closeCard
    
    var body: some View {
        
        VStack(spacing: 0) {
            header
                .padding(.vertical, 20)
            
            if horizontalSize == .regular {
                regular
            } else {
                compact
            }
        }
        .scaleEffect(vm.taskCase == .none ? 1 : 0.96)
        .ignoresSafeArea(.keyboard)
        .overlay(curtain)
        .overlay(
            todoItemTask
            ,alignment: .bottom
        )
        .onChange(of: vm.calendarInfo.date) { _ in
            withAnimation(.spring()){
                vm.entities()
            }
        }
    }
    
    //  MARK: - Layout
    private var compact: some View {
        VStack(spacing: 0) {
            GroupedCalendarView(info: $vm.calendarInfo, dates: vm.dates)
                .dividerShadow(opacity: 0.02, yOffset: 1)
                .floatShadow(opacity: 0.2, radius: 20, yOffset: 10)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            
            if vm.entitysGroupedByKind.isEmpty {
                VStack(spacing: 24) {
                    empty
                    
                    Text("") // For Offset ( TodoItemTask
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                        .padding(16 + 14)
                }
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                .padding(.horizontal, 16)
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
    }
    
    private var regular: some View {
        HStack(alignment: .top, spacing: 0) {
            GroupedCalendarView(info: $vm.calendarInfo, dates: vm.dates)
                .dividerShadow(opacity: 0.02, yOffset: 1)
                .floatShadow(opacity: 0.2, radius: 20, yOffset: 10)
                .frame(width: 320)
                .padding(.horizontal, 16)
                .padding(.bottom, horizontalSize == .regular ? 0 : 20)
            
            if vm.entitysGroupedByKind.isEmpty {
                VStack(spacing: 24) {
                    empty
                    
                    Text("") // For Offset ( TodoItemTask
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                        .padding(16 + 14)
                }
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                .padding(.horizontal, 16)
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
                        TodoItemView(entity, vm: vm)
//
                    }
                }
            }
            
        }
    }
    
    private var header: some View {
        HStack(spacing: 0){
            Text("Todo")
                .scaledFont(name: CustomFont.AbrilFatface, size: 25)
                .padding(.vertical, 2)
                .contentShape(Rectangle())
                .onTapGesture{
                    show()
                }
            
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
                KindPicker($vm.bindingKind, showKindView: $vm.showKindView, kinds: vm.kinds)
                    .contentShape(Rectangle())
                    .transition(
                        AnyTransition.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .bottom)),
                            removal: .opacity.animation(.easeIn(duration: 0.1))
                        )
                    )
                    .padding(.vertical, 20)
                    .sheet(isPresented: $vm.showKindView, onDismiss: {
                        withAnimation(defaultAnimation) {
                            vm.entities()
                            vm.kindEntitys()
                        }
                    }) {
                        KindView()
                    }
            }
            
            
            HStack(spacing: 8) {
                customTextField
                    .compositingGroup()
                    .floatShadow(opacity: vm.taskCase == .none ? 0.2 : 0, radius: 20, yOffset: 10)
                
                if vm.canTask {
                    submitTaskButton
                        .transition(
                            AnyTransition.asymmetric(insertion: .scale.animation(.closeCard),
                                                     removal: .opacity.animation(.easeIn(duration: 0.1)))
                        )
                }
                
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Color.theme.backgroundColor.opacity(0.01))
    }
    
    private var curtain: some View {
        Group {
            if vm.taskCase != .none {
                Rectangle()
                    .fill(Color.black)
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(defaultAnimation) {
                            vm.clearTask()
                        }
                    }
            }
        }
    }
    
    private var submitTaskButton: some View {
        Button(action: {
            switch vm.taskCase {
            case .add:
                withAnimation(defaultAnimation) {
                    vm.addEntity()
                    vm.clearTask()
                }

            case .edit:
                withAnimation(defaultAnimation) {
                    vm.updateEntity()
                    vm.clearTask()
                }
                
            case .none:
                print("error: impossible state of taskCase in onCommit")
                withAnimation(defaultAnimation) {
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
        TextField("Add New Todo", text: $vm.bindingText, onEditingChanged: {_ in}){
            switch vm.taskCase {
            case .add:
                if vm.canTask {
                    withAnimation(defaultAnimation){
                        vm.addEntity()
                        vm.clearTask()
                    }
                }
            case .edit:
                if vm.canTask {
                    withAnimation(defaultAnimation){
                        vm.updateEntity()
                        vm.clearTask()
                    }
                }
            case .none:
                print("error: impossible state of taskCase in onCommit")
            }
        }
        .introspectTextField(customize: { textField in
            //            textField.returnKeyType = .done
            if vm.taskCase != .none && vm.showKindView == false {
                textField.becomeFirstResponder()
            }
        })
        .disableAutocorrection(true)
        .overlay(
            Image(systemName: "xmark.circle.fill")
                .padding()
                .offset(x: 10)
                .foregroundColor(.secondary)
                .opacity(vm.bindingText.isEmpty ? 0.0 : 1.0)
                .onTapGesture {
            vm.bindingText = ""
        }
            , alignment: .trailing
        )
        .font(Font.system(.headline, design: .default).weight(.semibold))
        .padding(14).padding(.horizontal, 2)
        .frame(maxWidth: 400, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.theme.backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.theme.dividerColor)
        )
        .overlay(
            ZStack {
                if vm.taskCase == .none {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.theme.backgroundColor.opacity(0.01))
                        .onTapGesture{
                            withAnimation(defaultAnimation) {
                                vm.taskCase = .add
                            }
                        }
                }
            }
        )
        
    }
}
