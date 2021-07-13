//
//  AddTodoListView.swift
//  Statist
//
//  Created by Kimyaehoon on 13/07/2021.
//

import SwiftUI

struct AddTodoListView: View {
    
    @ObservedObject var vm: TodoListViewModel
    @State var name: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Add")
                Spacer()
                Image(systemName: "xmark.circle.fill")
            }
            .font(Font.system(.headline, design: .default).weight(.heavy))
            
            Divider()
                .foregroundColor(.theme.dividerColor)
            
            DatePicker("Date", selection: $vm.date, displayedComponents: .date)
                .font(Font.system(.subheadline, design: .default).weight(.bold))
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Name")
                    .font(Font.system(.subheadline, design: .default).weight(.bold))
                
                TextField("Write new Todo...", text: $name)
                    .foregroundColor(.primary)
                    .disableAutocorrection(true)
                    .overlay(
                        Image(systemName: "xmark.circle.fill")
                            .padding()
                            .offset(x: 10)
                            .foregroundColor(.secondary)
                            .opacity(name.isEmpty ? 0.0 : 1.0)
                            .onTapGesture {
                                UIApplication.shared.endEditing()
                                name = ""
                            }
                        , alignment: .trailing
                    )
                    .font(.footnote)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.theme.dividerColor)
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Kind")
                    .font(Font.system(.subheadline, design: .default).weight(.bold))
            }
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Add")
                    .font(Font.system(.headline, design: .default).weight(.semibold))
                    .frame(maxWidth: 414)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.primary)
                    )
                    .foregroundColor(Color(.systemBackground))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .padding(.horizontal, 16)
        
    }
}

struct AddTodoListView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoListView(vm: TodoListViewModel(date: Date()))
            .padding(.vertical)
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
}
