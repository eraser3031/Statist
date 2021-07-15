//
//  EditTodoView.swift
//  Statist
//
//  Created by Kimyaehoon on 15/07/2021.
//

import SwiftUI

struct EditTodoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var editingEntity: TodoListEntity?
    @StateObject var vm: EditTodoViewModel
    
    init(_ entity: Binding<TodoListEntity?>) {
        self._editingEntity = entity
        self._vm = StateObject(wrappedValue: EditTodoViewModel(entity: entity.wrappedValue))
    }
    
    var body: some View {
        VStack(spacing: 32){
            header
            
            date
            
            name
            
            kind
            
            Spacer()
            
            button
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }
}

extension EditTodoView {
    private var header: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Edit Todo")
                    .font(Font.system(.title3, design: .default).weight(.heavy))
                
                Spacer()
                
                Text("Cancel")
                    .font(Font.system(.subheadline, design: .default).weight(.semibold))
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            
            Divider()
                .foregroundColor(.theme.dividerColor)
        }
    }
    
    private var date: some View {
        VStack(alignment: .leading, spacing: 10){
            
            Text("Date")
                .font(Font.system(.subheadline, design: .default).weight(.bold))
            
            DatePicker("Select Todo Date", selection: $vm.date, displayedComponents: .date)
                .font(.callout)
                .foregroundColor(Color(.tertiaryLabel))
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.theme.dividerColor)
            )
        }
    }
    
    private var name: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Name")
                .font(Font.system(.subheadline, design: .default).weight(.bold))
            
            CustomTextField("Write New Todo", text: $vm.name)
        }
    }
    
    private var kind: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Kind")
                .font(Font.system(.subheadline, design: .default).weight(.bold))
            
            KindPicker($vm.kind, showAddKindView: $vm.showAddKindView, kinds: vm.kinds)
                .sheet(isPresented: $vm.showAddKindView,
                       onDismiss: {
                        withAnimation(.spring()){
                            vm.getKindEntitys()
                        }
                    }) {
                        AddKindView()
                }
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
                .shadow(color: .theme.shadowColor.opacity(0.2), radius: 40, x: 0, y: 20)
        }
    }
    
    private var button: some View {
        CustomButton("Save", nil) {
            vm.updateEntity()
            withAnimation {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .disabled(vm.isDisabled())
        .overlay(
            Color(.systemBackground).opacity(vm.isDisabled() ? 0.8 : 0)
        )
    }
}
