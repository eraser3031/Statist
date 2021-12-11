//
//  GoalView.swift
//  Statist
//
//  Created by Kimyaehoon on 22/08/2021.
//

import SwiftUI

struct GoalView: View {
    
    @StateObject var vm = GoalViewModel()
    let show: () -> Void
    
    @State var start = false
    let defaultAnimation = Animation.closeCard
    
    var body: some View {
        VStack(spacing: 0) {
            
            header
                .padding(.vertical, 20)
            
            HStack {
                CustomPicker(currentPick: $vm.goalCase, picks: [.finish, .recent])
                    .compositingGroup()
                
                Spacer()
                
                sortMenu
                    .compositingGroup()
            }
            .dividerShadow()
            .floatShadow(opacity: 0.2, radius: 20, yOffset: 20)
            .padding(.horizontal, 20)
            .padding(.bottom, 15)
            
            if start {
                if vm.goals.isEmpty {
                     Spacer()
                        .frame(maxWidth: .infinity)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 16) {
                            ForEach(vm.goals) { goal in
                                GoalItemView(entity: goal, vm: vm)
                                    .compositingGroup()
                            }
                        }
                        .padding(.top, 15)
                        .padding(.horizontal, 16)
                    }
                    .dividerShadow()
                    .floatShadow()
                }
            } else {
                Spacer()
            }
        }
        .overlay(
            taskButton
            ,alignment: .bottomTrailing
        )
        .sheet(isPresented: $vm.showTaskView, onDismiss: {vm.clearForTask()}){
            NavigationView {
                GoalTaskView(vm: vm)
            }.accentColor(.primary)
        }
        .onChange(of: vm.sortCase) { _ in
            withAnimation(defaultAnimation){
                vm.entities()
            }
        }
        .onChange(of: vm.goalCase) { _ in
            withAnimation(defaultAnimation){
                vm.entities()
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                withAnimation(defaultAnimation) {
                    start = true
                }
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 0){
            Text("Goal")
                .scaledFont(name: CustomFont.Gilroy_ExtraBold, size: 25)
                .padding(.vertical, 2)
                .contentShape(Rectangle())
                .onTapGesture{
                    show()
                }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private var sortMenu: some View {
        Menu {
            ForEach(SortCase.allCases) { sort in
                Button(action: {
                    withAnimation(defaultAnimation) {
                        vm.sortCase = sort
                    }
                }){
                    Label(sort.rawValue, systemImage: sort.labelImage)
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                }
            }
        } label: {
            HStack(spacing: 12) {
                Label("Sort", systemImage: vm.sortCase.labelImage)
                    .minimumScaleFactor(0.1)
                    .font(Font.system(.subheadline, design: .default).weight(.medium))
                
                Image(systemName: "chevron.down")
                    .font(Font.system(.subheadline, design: .default).weight(.semibold))
            }
            .padding(.vertical, 10).padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.theme.backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.theme.dividerColor)
            )
            .accentColor(.primary)
        }
    }
    
    private var taskButton: some View {
        Button(action: {
            withAnimation {
                vm.taskCase = .add
            }
        }) {
            ZStack {
                Circle()
                    .fill(Color.primary)
                    .frame(width: 52, height: 52)
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(Color.theme.backgroundColor)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
    }
}

//struct GoalView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalView()
//    }
//}
