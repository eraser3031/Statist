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
                Text("New Todo")
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .onTapGesture {
                        withAnimation(.spring()) {
                            vm.showAddTodoListView = false
                        }
                    }
            }
            .font(Font.system(.headline, design: .default).weight(.heavy))

            Divider()
                .foregroundColor(.theme.dividerColor)

            DatePicker("Date", selection: $vm.date, displayedComponents: .date)
                .font(Font.system(.subheadline, design: .default).weight(.bold))

            VStack(alignment: .leading, spacing: 10) {
                Text("Name")
                    .font(Font.system(.subheadline, design: .default).weight(.bold))

                CustomTextField("Write New Todo", text: $name)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Kind")
                    .font(Font.system(.subheadline, design: .default).weight(.bold))
                
                KindPicker()
                    .shadow(color: Color(#colorLiteral(red: 0.1333333333, green: 0.3098039216, blue: 0.662745098, alpha: 0.2)), radius: 40, x: 0.0, y: 20)
            }

            CustomButton("Add", "plus") {
                withAnimation(.spring()) {
                    vm.showAddTodoListView = false
                }
            }
            .disabled(false)
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
