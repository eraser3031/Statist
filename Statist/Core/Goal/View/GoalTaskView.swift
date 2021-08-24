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
            VStack(alignment: .leading, spacing: 32) {
                CustomSection {
                    Text("Name")
                        .foregroundColor(Color.primary)
                        .font(Font.system(.subheadline, design: .default).weight(.medium))
                } content: {
                    TextField("운동 10회 하기", text: $vm.nameForTask)
                }
                .padding(.horizontal, 16)
                
                CustomSection {
                    Text("Goal")
                        .foregroundColor(Color.primary)
                        .font(Font.system(.subheadline, design: .default).weight(.medium))
                } content: {
                    HStack {
                        TextField("0", text: $vm.goalForTask) { isEdit in
                            if !isEdit {
                                showtoolbar = false
                                let value = Int(vm.goalForTask) ?? 0
                                let result = value >= 365 ? 365 : value
                                vm.goalForTask = String(result)
                            } else {
                                showtoolbar = true
                            }
                        } onCommit: {}
                        .disableAutocorrection(true)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .padding(6)
                        .frame(width: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color(.tertiarySystemFill))
                        )
                        
                        Text("Times")
                        Spacer()
                        Stepper("", onIncrement: increase, onDecrement: decrement)
                    }
                }
                .padding(.horizontal, 16)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Kind")
                        .foregroundColor(Color.primary)
                        .font(Font.system(.subheadline, design: .default).weight(.medium))
                        .padding(.horizontal, 16)
                    
                    KindPicker($vm.kindForTask, showKindView: $vm.showKindView, kinds: vm.kinds)
                }

                
                CustomSection {
                    Text("Date")
                        .foregroundColor(Color.primary)
                        .font(Font.system(.subheadline, design: .default).weight(.medium))

                } content: {
                    DatePicker("\(distanceToEndDate()) days left", selection: $vm.endDateForTask, in: Date().toDay.nextDay()..., displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                if vm.isValid != .clear {
                    Text(vm.isValid.text)
                        .font(.footnote)
                        .foregroundColor(Color.red)
                        .padding()
                }
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("Save")
                    .accentColor(.primary)
                    .opacity(vm.isValid == .clear ? 1 : 0.3)
                    .onTapGesture {
                        if vm.isValid == .clear {
                            withAnimation {
                                vm.confirmTask()
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $vm.showKindView, onDismiss: nil){
            KindView()
        }
        .onAppear{
            vm.initForTask()
        }
    }
    
    private func distanceToEndDate() -> Int {
        return Calendar.current.distanceByDay(start: Date().toDay, end: vm.endDateForTask)
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

struct CustomSection<HeaderView, ContentView>: View where HeaderView: View, ContentView : View {
    let header: () -> HeaderView
    let content: () -> ContentView
    
    init(@ViewBuilder header: @escaping () -> HeaderView, @ViewBuilder content: @escaping () -> ContentView) {
        self.header = header
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header()
            
            content()
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.theme.itemBackgroundColor)
                )
        }
    }
}
