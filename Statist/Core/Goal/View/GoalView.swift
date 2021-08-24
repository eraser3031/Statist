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
    
    let defaultAnimation = Animation.closeCard
    
    var body: some View {
        VStack(spacing: 0) {
            
            header
                .padding(.vertical, 20)
            
            HStack {
                CustomPicker(currentPick: $vm.goalCase, picks: [.finish, .recent])
                
                Spacer()
                
                sortMenu
                    .compositingGroup()
            }
            .dividerShadow()
            .floatShadow(opacity: 0.2, radius: 20, yOffset: 20)
            .padding(.horizontal, 20)
            .padding(.bottom, 15)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(vm.goals) { goal in
                        GoalItemView(entity: goal, vm: vm)
                    }
                }
                .padding(.top, 15)
                .padding(.horizontal, 16)
            }
            .dividerShadow()
            .floatShadow()
        }
        .overlay(
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
            ,alignment: .bottomTrailing
        )
        .sheet(isPresented: $vm.showTaskView, onDismiss: {vm.clearForTask()}){
            NavigationView {
                GoalTaskView(vm: vm)
            }
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
        
    }
    
    private var header: some View {
        HStack(spacing: 0){
            Text("Goal")
                .scaledFont(name: CustomFont.AbrilFatface, size: 25)
                .padding(.vertical, 2)
                .contentShape(Rectangle())
                .onTapGesture{
                    show()
                }
            
            Spacer()
            
            Circle()
                .frame(width: 32, height: 32)
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
}

//struct GoalView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalView()
//    }
//}