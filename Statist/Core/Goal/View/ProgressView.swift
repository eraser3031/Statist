//
//  ProgressView.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//
// 이번주안에 스탯 뷰 완성은 무난하게 가능할 듯. 그리고 다음 주엔 플래너 디자인과 인식기능 추가 -> 화이팅..
import SwiftUI

struct ProgressView: View {
    
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
                    progressButtons(entity)
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
    
    private func progressButtons(_ entity: ProgressEntity) -> some View {
        HStack(spacing: 10) {
            cancelProgressButton(entity)
            
            if entity.isNotFinish {
                progressButton(entity)
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
    
    private func cancelProgressButton(_ entity: ProgressEntity) -> some View {
        Circle()
            .stroke(Color.theme.dividerColor)
            .frame(width: 44, height: 44)
            .overlay(
                Image(systemName: "arrow.uturn.left")
                    .font(Font.system(.footnote, design: .default).weight(.bold))
            )
            .onTapGesture {
                vm.deleteProgressPoint(entity)
            }
    }
    
    private func progressButton(_ entity: ProgressEntity) -> some View {
        Circle()
            .fill(entity.kindEntity?.color.toPrimary() ?? Color.primary)
            .frame(width: 44, height: 44)
            .overlay(
                Image(systemName: "arrow.right")
                    .font(Font.system(.footnote, design: .default).weight(.bold))
                    .foregroundColor(Color(.systemBackground))
            )
            .onTapGesture {
                progress(entity)
            }
    }
    
    private func progress(_ entity: ProgressEntity) {
        vm.addProgressPoint(entity)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
