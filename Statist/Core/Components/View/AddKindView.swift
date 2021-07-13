//
//  AddKindView.swift
//  Statist
//
//  Created by Kimyaehoon on 13/07/2021.
//

import SwiftUI

struct AddKindView: View {
    
    @ObservedObject var vm: KindViewModel
    @State var name: String = ""
    @State var selectedColor: ColorKind = .red
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("New Kind")
                Spacer()
                Image(systemName: "xmark.circle.fill")
            }
            .font(Font.system(.headline, design: .default).weight(.heavy))
            
            Divider()
                .foregroundColor(.theme.dividerColor)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Name")
                    .font(Font.system(.subheadline, design: .default).weight(.bold))
                
                CustomTextField("Write New Kind Name", text: $name)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Color")
                    .font(Font.system(.subheadline, design: .default).weight(.bold))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(ColorKind.allCases) { colorKind in
                            Circle()
                                .strokeBorder()
                                .frame(width: 48, height: 48)
                                .background(
                                    colorKind.toPrimary()
                                )
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .opacity(colorKind == selectedColor ? 1 : 0)
                                )
                                .onTapGesture {
                                    selectedColor = colorKind
                                }
                        }
                    }
                }
            }
            
            CustomButton("Add", "plus") {
                vm.addKindEntity(name, color: selectedColor)
                withAnimation(.spring()) {
                    vm.showAddKindView = false
                }
            }
            .disabled(name.isEmpty)
            
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .padding(.horizontal, 12)
    }
}

struct AddKindView_Previews: PreviewProvider {
    static var previews: some View {
        AddKindView(vm: KindViewModel())
            .padding()
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
}

