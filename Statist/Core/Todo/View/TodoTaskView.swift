//
//  TodoTaskView.swift
//  Statist
//
//  Created by Kimyaehoon on 25/08/2021.
//

import SwiftUI

struct TodoTaskView: View {
    
    @ObservedObject var vm: TodoViewModel
    let confirmText: LocalizedStringKey
    let confirmImage: String
    
    let defaultAnimation = Animation.closeCard
    
    init(vm: TodoViewModel) {
        self.vm = vm
        
        self.confirmText = vm.taskCase == .edit ? "Edit" : "Add"
        self.confirmImage = vm.taskCase == .edit ? "pencil" : "plus"
    }
    
    var body: some View {
        VStack(spacing: 32) {
            header
                .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("kind")
                        .foregroundColor(Color.primary)
                        .scaledFont(name: CustomFont.Gilroy_ExtraBold, size: 15)
                        .padding(.horizontal, 20)
                    
                    KindPicker($vm.bindingKind, showKindView: $vm.showKindView, kinds: vm.kinds)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("name")
                        .foregroundColor(Color.primary)
                        .scaledFont(name: CustomFont.Gilroy_ExtraBold, size: 15)
                    
                    TextField("Solve 10 math problems",
                              text: $vm.bindingText,
                              onEditingChanged: {_ in },
                              onCommit: {
                        if vm.canTask {
                            withAnimation(defaultAnimation) {
                                vm.confirmTask()
                            }
                        }
                    })
                    .introspectTextField(customize: { textField in
                        if vm.taskCase != .none && vm.showKindView == false {
                            if !textField.isFirstResponder {
                                textField.becomeFirstResponder()
                            }
                        }
                    })
                    .font(.body)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.theme.itemBackgroundColor)
                    )
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.theme.backgroundColor)
        )
        .frame(maxWidth: 400)
        .sheet(isPresented: $vm.showKindView, onDismiss: {vm.kindEntities()} ){
            KindView()
        }
        .padding(16)
    }
    
    private var header: some View {
        HStack {
            Button(action: {
                withAnimation(defaultAnimation) {
                    vm.clearTask()
                }
            }) {
                Text("Cancel")
                    .font(Font.system(.subheadline, design: .default).weight(.medium))
                    .foregroundColor(Color(.systemGray3))
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(defaultAnimation) {
                    vm.confirmTask()
                }
            }){
                Label(confirmText, systemImage: confirmImage)
                    .font(Font.system(.subheadline, design: .default).weight(.bold))
                    .foregroundColor(.primary)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!vm.canTask)
            .opacity(vm.canTask ? 1 : 0.5)
        }
    }
}

//struct TodoTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoTaskView()
//    }
//}
