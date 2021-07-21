//
//  ProgressView.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct ProgressView: View {
    
    @EnvironmentObject var environment: StatistViewModel
    @StateObject var vm: ProgressViewModel
    
    init(){
        self._vm = StateObject(wrappedValue: ProgressViewModel())
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 50){
                
                progressList
                
                CustomButton("Add", "plus", isPrimary: false) {
                    vm.showAddProgressView = true
                }
                .padding(.bottom, 20)
            }
        }
        .padding(.horizontal, 20)
        .shadow(color: Color(#colorLiteral(red: 0.1333333333, green: 0.3098039216, blue: 0.662745098, alpha: 0.1)), radius: 20, x: 0.0, y: 10)
        .sheet(isPresented: $vm.showAddProgressView,
               onDismiss: {
                withAnimation(.spring()){
                    vm.getProgressEntitys()
                }
            }) {
                AddProgressView()
        }
        .sheet(isPresented: $vm.showEditProgressView,
               onDismiss: {
                withAnimation(.spring()){
                    vm.getProgressEntitys()
                }
            }) {
                EditProgressView($vm.editingEntity)
        }
    }
}

extension ProgressView {
    private var progressList: some View {
        VStack(spacing: 20) {
            ForEach(vm.progressEntitys) { entity in
                ProgressItemView(entity: entity) {
                    vm.save()
                }
                .contextMenu {
                    Button(action: { edit(entity) }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Divider()
                    
                    Button(action: { delete(entity) }) {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .transition(.opacity)
            }
        }
    }
    
    private func edit(_ entity: ProgressEntity) {
        withAnimation(.spring()) {
            vm.editingEntity = entity
        }
        vm.showEditProgressView = true
    }
    
    private func delete(_ entity: ProgressEntity) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring()) {
                vm.deleteProgressEntity(entity: entity)
            }
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
