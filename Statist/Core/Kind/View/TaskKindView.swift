//
//  TaskKindView.swift
//  Statist
//
//  Created by Kimyaehoon on 12/08/2021.
//

import SwiftUI

struct TaskKindView: View {
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
        VStack(spacing: 20){
            
            NavigationLink(destination: EmptyView()) {
                EmptyView()
            }
            
            Spacer().frame(height: 0)
            
            CustomTextField("Write Kind's Name", text: $vm.text)
                .padding(.horizontal, 20)
            
            CustomColorPicker($vm.color)
            
            Spacer()
            
            if vm.isOverlap {
                Text("kind's name shouldn't ovelap other kinds")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Button(action: {
                if vm.isEdit {
                    vm.editKindEntity()
                    save()
                    presentationMode.wrappedValue.dismiss()
                } else {
                    vm.addKindEntity()
                    save()
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Label(vm.isEdit ? "Edit" : "Add", systemImage: vm.isEdit ? "pencil" : "plus")
            }
            .buttonStyle(TaskButtonStyle())
            .padding([.bottom, .horizontal], 20)
            .opacity(vm.isDisabled ? 0.5 : 1)
            .disabled(vm.isDisabled)
            
        }
        .background(
            Group {
                if vm.isEdit {
                    Color(.systemBackground)
                        .toolbar{
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Text("Delete")
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        vm.alertDelete = true
                                    }
                            }
                        }
                } else {
                    EmptyView()
                }
            }
        )
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
