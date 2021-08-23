//
//  MenuView.swift
//  Statist
//
//  Created by Kimyaehoon on 16/08/2021.
//

import SwiftUI

enum TaskCase: String {
    case edit
    case add
    case none
}

enum MenuCase: String {
    case todo
    case timeTable
    case goal
    case stat
}

struct MenuView: View {
    @State var menuCase: MenuCase = .todo
    @State var showMenu = false
    
    @Environment(\.horizontalSizeClass) var horizontalSize
    
    let menuAnimation = Animation.moreCloseCard
    
    private func show() {
        withAnimation(menuAnimation) {
            showMenu = true
        }
    }
    
    private func changeMenu(_ menu: MenuCase) {
        menuCase = menu
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
            withAnimation(menuAnimation) {
                showMenu = false
                
            }
        }
    }
    
    private func calPanelOffset(proxy: GeometryProxy) -> CGFloat {
        -proxy.size.width / 2 - 30
    }
    
    private func calMainViewOffset(proxy: GeometryProxy) -> CGFloat {
        return horizontalSize == .compact ? proxy.size.width / 5 * 4 : proxy.size.width / 3
    }
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                GridPatternView()
                
                panel
                    .padding(.horizontal, 30)
                    .padding(.top, 36)
                    .offset(x: showMenu ? 0 : calPanelOffset(proxy: geo) )
            
                mainView(geo: geo)
                    .ignoresSafeArea(showMenu ? [] : .all, edges: .all)
                    .padding(.vertical, showMenu ? 20 : 0)
                    .offset(x: showMenu ? calMainViewOffset(proxy: geo) : 0)

            }
        }
    }
    
    private func mainView(geo: GeometryProxy) -> some View {
        ZStack {
            if menuCase == .todo {
                TodoView(){ show() }
            } else if menuCase == .timeTable {
                TimetableView(){ show() }
            } else if menuCase == .goal {
                GoalView(){ show() }
            } else if menuCase == .stat {
                EmptyView()
            }
//            .frame(width: UIScreen.main.bounds.width)
        }
        .padding(.top, geo.safeAreaInsets.top)
        .padding(.bottom, geo.safeAreaInsets.bottom)
        .overlay(
            Color.black.opacity(showMenu ? 0.6 : 0)
                .onTapGesture {
                    changeMenu(menuCase)
                }
        )
        .background(
            Color.theme.backgroundColor
        )
        .clipShape(RoundedRectangle(cornerRadius: showMenu ? 30 : 0, style: .continuous))
        .shadow(color: Color.theme.shadowColor.opacity(showMenu ? 0.4 : 0), radius: 40, x: 0.0, y: 20)
    }
    
    private var panel: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 50) {
                Circle()
                    .fill(Color.primary)
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 30) {
                    Text("Todo").onTapGesture {changeMenu(.todo) }
                    Text("Timetable").onTapGesture {changeMenu(.timeTable) }
                    Text("Goal").onTapGesture {changeMenu(.goal) }
                }
                .scaledFont(name: CustomFont.AbrilFatface, size: 28)
//                .font(Font.system(.title, design: .default).weight(.heavy))
                
                GeometryReader { geo in
                    Capsule()
                        .fill(Color.primary)
                        .frame(maxWidth: horizontalSize == .compact ? geo.size.width/2 : geo.size.width/3 - 60)
                }
                .frame(height: 2)
                
                Text("Stat").onTapGesture {changeMenu(.goal) }
                    .scaledFont(name: CustomFont.AbrilFatface, size: 28)
//                    .font(Font.system(.title, design: .default).weight(.heavy))
                
                Spacer()
            }
        }
    }
}

struct ContainerView<InnerView>: View where InnerView: View {
    let content: () -> InnerView
    @State var start = false
    
    init(@ViewBuilder content: @escaping () -> InnerView){
        self.content = content
    }
    
    var body: some View {
        ZStack {
            if start {
                content()
            } else {
                Color.theme.groupBackgroundColor.opacity(0.01)
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                withAnimation(.easeInOut(duration: 0.3)) {
                    start = true
                }
            }
        }
        
    }
}


//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView()
//    }
//}
