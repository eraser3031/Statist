//
//  AddKindView.swift
//  Statist
//
//  Created by Kimyaehoon on 14/07/2021.
//

import SwiftUI

struct AddKindView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm = AddKindViewModel()
    
    var body: some View {
            VStack(spacing: 30) {
                
                Spacer().frame(height: 0)
                
                name
                
                color
                
                Color(.systemBackground)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                
                if vm.isOverlap {
                    Text("kind's name shouldn't ovelap other kinds")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                button
                    .padding(.bottom, 20)
            }
            .navigationBarTitle("Add Kind", displayMode: .inline)
    }
}

extension AddKindView {
    
    private var name: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Name")
                .font(Font.system(.subheadline, design: .default).weight(.bold))
            
            CustomTextField("Write New Todo", text: $vm.name)
        }
        .padding(.horizontal, 20)
    }
    
    private var color: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Color")
                .font(Font.system(.subheadline, design: .default).weight(.bold))
                .padding(.horizontal, 20)
            
            CustomColorPicker($vm.colorKind)
        }

    }
    
    private var button: some View {
        CustomButton("Add", "plus") {
            vm.addKindEntity()
            presentationMode.wrappedValue.dismiss()
        }
        .disabled(vm.isDisabled())
        .overlay(
            Color(.systemBackground).opacity(vm.isDisabled() ? 0.8 : 0)
        )
    }
}

struct AddKindView_Previews: PreviewProvider {
    static var previews: some View {
        AddKindView()
    }
}
