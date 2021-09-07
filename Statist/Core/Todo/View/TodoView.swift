//
//  TodoView.swift
//  Statist
//
//  Created by Kimyaehoon on 06/08/2021.
//

import SwiftUI
import Introspect
import Combine

struct TodoView: View {
    @Environment(\.horizontalSizeClass) var horizontalSize
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject var vm = TodoViewModel()
    @Namespace private var namespace
    @State private var keyboardHeight: CGFloat = 0
    
    let show: () -> Void
    
    @State var start = false
    let defaultAnimation = Animation.closeCard
    
    var body: some View {
        
        VStack(spacing: 0) {
            header
                .padding(.vertical, 20)
            
            if start {
                if horizontalSize == .regular {
                    regular
                } else {
                    compact
                }
            } else {
                Spacer()
            }
        }
        .overlay(
            taskButton
            .padding()
            ,alignment: .bottomTrailing
        )
        .blur(radius: vm.taskCase == .none ? 0 : 16)
        .overlay(curtain)
        .overlay(
            TodoTaskView(vm: vm)
                .compositingGroup()
                .dividerShadow()
                .floatShadow()
                .transition(.move(edge: .bottom))
                .padding(.bottom, keyboardHeight - safeAreaInsets.bottom)
                .offset(y: vm.taskCase == .none ? 400 : 0 )
            ,alignment: .bottom
        )
        .ignoresSafeArea(.keyboard)
        .onChange(of: vm.calendarInfo.date) { _ in
            withAnimation(.spring()){
                vm.entities()
            }
        }
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                withAnimation(defaultAnimation) {
                    start = true
                }
            }
        }
    }
    
    //  MARK: - Layout
    private var compact: some View {
        VStack(spacing: 0) {
            GroupedCalendarView(info: $vm.calendarInfo, dates: vm.dates)
                .dividerShadow(opacity: 0.02, yOffset: 1)
                .floatShadow(opacity: 0.2, radius: 20, yOffset: 10)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            
            if vm.entitysGroupedByKind.isEmpty {
                VStack(spacing: 24) {
                    empty
                    
                    Text("") // For Offset ( TodoItemTask
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                        .padding(16 + 14)
                }
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                .padding(.horizontal, 16)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 28){
                        todoList
                        
                        Text("") // For Offset ( TodoItemTask
                            .font(Font.system(.subheadline, design: .default).weight(.semibold))
                            .padding(16 + 20)
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    
    private var regular: some View {
        HStack(alignment: .top, spacing: 0) {
            GroupedCalendarView(info: $vm.calendarInfo, dates: vm.dates)
                .dividerShadow(opacity: 0.02, yOffset: 1)
                .floatShadow(opacity: 0.2, radius: 20, yOffset: 10)
                .frame(width: 320)
                .padding(.horizontal, 16)
                .padding(.bottom, horizontalSize == .regular ? 0 : 20)
            
            if vm.entitysGroupedByKind.isEmpty {
                VStack(spacing: 24) {
                    empty
                    
                    Text("") // For Offset ( TodoItemTask
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                        .padding(16 + 14)
                }
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                .padding(.horizontal, 16)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 28){
                        todoList
                        
                        Text("") // For Offset ( TodoItemTask
                            .font(Font.system(.subheadline, design: .default).weight(.semibold))
                            .padding(16 + 20)
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    
    //  MARK: - Components
    
    
    private var todoList: some View {
        ForEach(vm.entitysGroupedByKind, id: \.id) { groupedByKind in
            
            let entitys = groupedByKind.entitys
            let kind = groupedByKind.kindEntity
            let name = kind.name ?? ""
            let primaryColor = kind.color.primary()
            
            VStack(alignment: .leading, spacing: 0){
                HStack(spacing: 8) {
                    Circle()
                        .fill(primaryColor)
                        .frame(width: 10, height: 10)
                    
                    Text(name)
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                }
                .padding(.vertical, 12)
                
                VStack(spacing: 12) {
                    ForEach(entitys) { entity in
                        TodoItemView(entity, vm: vm)
                    }
                }
                .compositingGroup()
                .dividerShadow(opacity: 0.01, radius: 1, yOffset: 1)
                .floatShadow(opacity: 0.1, radius: 30, yOffset: 16)
            }
            
        }
    }
    
    private var header: some View {
        HStack(spacing: 0){
            Text("Todo")
                .scaledFont(name: CustomFont.AbrilFatface, size: 25)
                .padding(.vertical, 2)
                .contentShape(Rectangle())
                .onTapGesture{
                    show()
                }
            
            Spacer()
        
        }
        .padding(.horizontal, 20)
    }
    
    private var empty: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.theme.subBackgroundColor)
//            .frame(height: 300)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.theme.dividerColor,
                            style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [8]))
                    .padding(1)
            )
            .overlay(
                VStack(spacing: 4) {
                Image(systemName: "moon.zzz.fill")
                    .font(.title2)
                
                Text("Todo is empty")
                    .font(.footnote)
            }
                    .foregroundColor(.secondary)
            )
    }
    
    private var taskButton: some View {
        Button(action: {
            withAnimation(defaultAnimation) {
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
    }
    
    private var curtain: some View {
        ZStack {
            if vm.taskCase != .none {
                Color.theme.backgroundColor.opacity(0.01)
                    .onTapGesture {
                        withAnimation(defaultAnimation) {
                            vm.clearTask()
                        }
                    }
            }
        }
    }
}
