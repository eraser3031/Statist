//
//  TaskKindView.swift
//  Statist
//
//  Created by Kimyaehoon on 12/08/2021.
//

import SwiftUI

struct KindTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: TaskKindViewModel
    let kind: KindEntity?
    let save: () -> Void
    
    init(_ kind: KindEntity?, kinds: [KindEntity], save: @escaping () -> Void) {
        self._vm = StateObject(wrappedValue: TaskKindViewModel(kind, kinds: kinds))
        self.kind = kind
        self.save = save
        
    }
    
    var body: some View {
        VStack(spacing: 30){
            
            VStack(alignment: .leading, spacing: 10) {
                    
                Text("name")
                    .foregroundColor(Color.primary)
                    .scaledFont(name: CustomFont.Gilroy_ExtraBold, size: 15)
                
                TextField("Write Kind's Name", text: $vm.text)
                    .font(.body)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.theme.itemBackgroundColor)
                    )
            }
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("color")
                    .foregroundColor(Color.primary)
                    .scaledFont(name: CustomFont.Gilroy_ExtraBold, size: 15)
                
                CustomColorPicker($vm.color)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            if vm.isOverlap {
                Text("kind's name shouldn't ovelap other kinds")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            
            Button(action: {
                vm.alertDelete = true
            }) {
                Label("Delete", systemImage: "trash.fill")
                    .foregroundColor(.red)
                    .frame(height: 50).frame(maxWidth: 400)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.theme.groupBackgroundColor)
                    )
            }
            .buttonStyle(InteractiveButtonStyle())
            .padding(.horizontal, 20)
            .opacity(vm.isEdit ? 1 : 0)
            
        }
        .padding(.vertical, 30)
        .toolbar{ 
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(vm.isEdit ? "Edit" : "Add")
                    .bold()
                    .opacity(vm.isOverlap ? 0.5 : 1)
                    .foregroundColor(Color.primary)
                    .onTapGesture {
                        if vm.isEdit && !vm.isOverlap {
                            vm.editKindEntity()
                            save()
                            presentationMode.wrappedValue.dismiss()
                        } else if !vm.isEdit && !vm.isOverlap {
                            vm.addKindEntity()
                            save()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            }
        }
        .alert(isPresented: $vm.alertDelete){
            
            Alert(title: Text("remove all data"), message: Text("all really?"),
                  primaryButton: .cancel(),
                  secondaryButton: .destructive(Text("Delete All"), action: {
                vm.deleteKindEntity()
                save()
                presentationMode.wrappedValue.dismiss()
            }))
        }
        .navigationBarTitle(kind == nil ? "Add Kind" : "Edit Kind", displayMode: .inline)
    }
}


//struct TaskKindView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskKindView()
//    }
//}
