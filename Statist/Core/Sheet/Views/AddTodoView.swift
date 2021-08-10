//
//  AddTodoView.swift
//  Statist
//
//  Created by Kimyaehoon on 14/07/2021.
//

import SwiftUI

struct AddTodoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: AddTodoViewModel
    
    let manager = CoreDataManager.instance
    
    init(date: Date) {
        self._vm = StateObject(wrappedValue: AddTodoViewModel(date: date))
    }
    
    var body: some View {
        VStack(spacing: 32) {
            
            header
             
            date
            
            name
             
            kind
            
            Spacer()
            
            button
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .padding(.bottom, 20)
    }
}

extension AddTodoView {
    private var header: some View {
        VStack(spacing: 20) {
            HStack {
                Text("New Todo")
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .onTapGesture {
                        withAnimation(.spring()) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            }
            .font(Font.system(.title3, design: .default).weight(.heavy))
            
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
            
//            KindPicker($vm.selectedKind, showAddKindView: $vm.showAddKindView, kinds: vm.kinds)
//                .sheet(isPresented: $vm.showAddKindView,
//                       onDismiss: {
//                        withAnimation(.spring()){
//                            vm.getKindEntitys()
//                        }
//                    }) {
//                        AddKindView()
//                }
//                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
//                .shadow(color: .theme.shadowColor.opacity(0.3), radius: 30, x: 0, y: 40)
        }
    }
    
    private var button: some View {
        CustomButton("Add", "plus") {
            vm.addTodoListEntity()
            presentationMode.wrappedValue.dismiss()
        }
        .disabled(vm.isDisabled())
        .overlay(
            Color(.systemBackground).opacity(vm.isDisabled() ? 0.8 : 0)
        )

    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView(date: Date())
    }
}
