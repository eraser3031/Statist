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
        VStack(spacing: 32) {
            
            header
            
            name
            
            color
                        
            Spacer()
            
            if vm.isOverlap {
                Text("kind's name shouldn't ovelap other kinds")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            button
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }
}

extension AddKindView {
    private var header: some View {
        VStack(spacing: 20) {
            HStack {
                Text("New Kind")
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
    
    private var name: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Name")
                .font(Font.system(.subheadline, design: .default).weight(.bold))
            
            CustomTextField("Write New Todo", text: $vm.name)
        }
    }
    
    private var color: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Color")
                .font(Font.system(.subheadline, design: .default).weight(.bold))
            
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
