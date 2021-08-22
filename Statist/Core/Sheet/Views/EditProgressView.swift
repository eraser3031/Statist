////
////  EditProgressView.swift
////  Statist
////
////  Created by Kimyaehoon on 21/07/2021.
////
//
//import SwiftUI
//
//struct EditProgressView: View {
//    
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject var vm: EditProgressViewModel
//    @Binding var editingEntity: ProgressEntity?
//    
//    init(_ entity: Binding<ProgressEntity?>) {
//        self._editingEntity = entity
//        self._vm = StateObject(wrappedValue: EditProgressViewModel(entity: entity.wrappedValue))
//    }
//    
//    var body: some View {
//        VStack(spacing: 32){
//            
//            header
//            
//            name
//            
//            goal
//            
//            kind
//            
//            Spacer()
//            
//            button
//
//        }
//        .padding(.horizontal, 20)
//        .padding(.top, 30)
//        .padding(.bottom, 20)
//    }
//}
//
//extension EditProgressView {
//    private var header: some View {
//        VStack(spacing: 20) {
//            HStack {
//                Text("Edit Progress")
//                Spacer()
//                
//                Text("Cancel")
//                    .font(Font.system(.subheadline, design: .default).weight(.semibold))
//                    .onTapGesture {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//            }
//            .font(Font.system(.title3, design: .default).weight(.heavy))
//            
//            Divider()
//                .foregroundColor(.theme.dividerColor)
//        }
//    }
//    
//    private var name: some View {
//        VStack(alignment: .leading, spacing: 10){
//            Text("Name")
//                .font(Font.system(.subheadline, design: .default).weight(.bold))
//            
//            CustomTextField("Write New Progress", text: $vm.name)
//        }
//    }
//    
//    private var goal: some View {
//        VStack(alignment: .leading, spacing: 10){
//            Text("Goal")
//                .font(Font.system(.subheadline, design: .default).weight(.bold))
//            
//            Slider(value: $vm.goal, in: 0...20, step: 1)
//                .accentColor(vm.selectedKind?.color.toPrimary() ?? .primary)
//        }
//    }
//    
//    private var kind: some View {
//        VStack(alignment: .leading, spacing: 10){
//            Text("Kind")
//                .font(Font.system(.subheadline, design: .default).weight(.bold))
//            
////            KindPicker($vm.selectedKind, showAddKindView: $vm.showAddKindView, kinds: vm.kinds)
////                .sheet(isPresented: $vm.showAddKindView,
////                       onDismiss: {
////                        withAnimation(.spring()){
////                            vm.getKindEntitys()
////                        }
////                    }) {
////                        AddKindView()
////                }
////                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
////                .shadow(color: .theme.shadowColor.opacity(0.3), radius: 30, x: 0, y: 40)
//        }
//    }
//    
//    private var button: some View {
//        CustomButton("Save", nil) {
//            vm.updateProgressEntity()
//            presentationMode.wrappedValue.dismiss()
//        }
//        .disabled(vm.isDisabled())
//        .overlay(
//            Color(.systemBackground).opacity(vm.isDisabled() ? 0.8 : 0)
//        )
//
//    }
//}
