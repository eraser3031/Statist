//
//  GoalTaskView.swift
//  Statist
//
//  Created by Kimyaehoon on 22/08/2021.
//

import SwiftUI

struct GoalTaskView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: GoalViewModel
    @State var showtoolbar = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("kind")
                        .foregroundColor(Color.primary)
                        .scaledFont(name: CustomFont.Gilroy_ExtraBold, size: 15)
                        .padding(.horizontal, 16)
                    
                    KindPicker($vm.kindForTask, showKindView: $vm.showKindView, kinds: vm.kinds)
                }
                
                CustomSection(label: "name") {
                    TextField("운동 10회 하기", text: $vm.nameForTask)
                        .font(.subheadline)
                        .padding(6)
                }.padding(.horizontal, 16)
                
                CustomSection(label: "date") {
                    DatePicker("\(distanceToEndDate()) days left",
                               selection: $vm.endDateForTask,
                               in: Date().toDay.nextDay()...,
                               displayedComponents: .date)
                        .font(Font.system(.headline, design: .default).weight(.medium))
                        .datePickerStyle(.compact)
                        .padding(.leading, 8)
                }.padding(.horizontal, 16)
                
                CustomSection(label: "count") {
                    HStack {
                        TextField("0", text: $vm.goalForTask, onEditingChanged: onEditingChanged, onCommit: {})
                        .font(.headline)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 6)
                        .frame(width: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color(.tertiarySystemFill))
                        )
                        
                        Text("times")
                            .font(Font.system(.headline, design: .default).weight(.medium))
                        Spacer()
                        Stepper("", onIncrement: increase, onDecrement: decrement)
                    }
                    
                }.padding(.horizontal, 16)
            }
        }
        .background(
            Color.theme.groupBackgroundColor.opacity(0.01)
                .contentShape(Rectangle())
                .onTapGesture {
            UIApplication.shared.endEditing()
        }
        )
        .overlay(
            ZStack {
            if showtoolbar {
                HStack {
                    Spacer()
                    Text("Done")
                        .font(.headline)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                        }
                }
                .padding([.top, .horizontal], 16)
                .background(
                    colorScheme == .dark ? Color(.systemGroupedBackground) : Color.theme.backgroundColor
                )
                .overlay(Rectangle().fill(Color.theme.dividerColor).frame(height: 1), alignment: .top)
            }
        }
            ,alignment: .bottom
        )
        .navigationTitle(vm.taskCase == .add ? "New Goal" : "Edit Goal")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.vertical, 20)
        .toolbar{
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    vm.clearForTask()
                }){
                    Text("Cancel")
                        .accentColor(Color(.systemGray3))
                        .font(.body)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.closeCard) {
                        vm.confirmTask()
                    }
                }){
                    Text("Save")
                        .accentColor(.primary)
                        .font(.headline)
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(!vm.isValid.isEmpty ? 0.3: 1)
                .disabled(!vm.isValid.isEmpty)
            }
        }
        .sheet(isPresented: $vm.showKindView, onDismiss: {vm.kindEntities()}){
            KindView()
        }
        .onAppear{
            vm.initForTask()
        }
    }
    
    private func distanceToEndDate() -> Int {
        return Calendar.current.distanceByDay(start: Date().toDay, end: vm.endDateForTask)
    }
    
    private func onEditingChanged(isEdit: Bool) {
        if !isEdit {
            showtoolbar = false
            let value = Int(vm.goalForTask) ?? 0
            let result = value >= 365 ? 365 : value
            vm.goalForTask = String(result)
        } else {
            showtoolbar = true
        }
    }
    
    private func increase(){
        let value = Int(vm.goalForTask) ?? 0
        let result = value + 1 >= 365 ? 365 : value + 1
        vm.goalForTask = String(result)
    }
    
    private func decrement(){
        let value = Int(vm.goalForTask) ?? 0
        let result = value - 1 <= 0 ? 0 : value - 1
        vm.goalForTask = String(result)
    }
}

struct CustomSection<ContentView>: View where ContentView: View {
    
//    @Binding var bindingRules: [ValidCase]
    
    let label: LocalizedStringKey
//    let matchedRules: [ValidCase]
    let content: () -> ContentView
    
    init(label: LocalizedStringKey,
//         matchedRules: [ValidCase] = [],
//         bindingRules: Binding<[ValidCase]>,
         @ViewBuilder content: @escaping () -> ContentView) {
        self.label = label
//        self.matchedRules = matchedRules
//        self._bindingRules = bindingRules
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(label)
                .foregroundColor(Color.primary)
                .scaledFont(name: CustomFont.Gilroy_ExtraBold, size: 15)
            
            content()
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.theme.itemBackgroundColor)
                )
            
//            if let rule = matchedRules.first {
//                if bindingRules.contains(rule) {
//                    Text(rule.text)
//                        .font(Font.system(.caption, design: .default).weight(.medium))
//                        .foregroundColor(.red)
//                }
//            }
        }
    }
}

//struct CustomSection<HeaderView, ContentView>: View where HeaderView: View, ContentView : View {
//    let header: () -> HeaderView
//    let content: () -> ContentView
//
//    init(@ViewBuilder header: @escaping () -> HeaderView, @ViewBuilder content: @escaping () -> ContentView) {
//        self.header = header
//        self.content = content
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            header()
//
//            content()
//                .padding(10)
//                .background(
//                    RoundedRectangle(cornerRadius: 8, style: .continuous)
//                        .fill(Color.theme.itemBackgroundColor)
//                )
//        }
//    }
//}
