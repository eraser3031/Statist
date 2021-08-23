//
//  TimetableView.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI
import PopupView

struct TimetableView: View {
    @Environment(\.horizontalSizeClass) var horizontalSize
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @StateObject var vm = NewTimetableViewModel()
    let show: () -> Void
    
    let defaultAnimation = Animation.closeCard
    let drawAnimation = Animation.flipCard
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                    .padding(.vertical, 20)
                
                if horizontalSize == .regular {
                    regular
                } else {
                    compact
                }
            }
            .onChange(of: vm.calendarInfo.date) { _ in
                withAnimation(defaultAnimation){
                    vm.isModified = false
                    vm.entities()
                }
            }
        }
        .overlay(
            Color.black.opacity(vm.showKindMenuView ? 0.4 : 0)
                .ignoresSafeArea()
                .onTapGesture {
            withAnimation(.linear(duration: 0.1)) {
                vm.showKindMenuView = false
            }
        }
        )
        .popup(isPresented: $vm.showKindMenuView,
               type: .floater(verticalPadding: safeAreaInsets.bottom + 8),
               position: .bottom,
               animation: .closeCard,
               dragToDismiss: true,
               closeOnTap: false,
               closeOnTapOutside: false,
               dismissCallback: {}) {
            KindMenuSheet(selectedKind: $vm.selectedKind, showKindMenuView: $vm.showKindMenuView, showKindView: $vm.showKindView, kinds: vm.kinds)
                .floatShadow()
        }
               .sheet(isPresented: $vm.showKindView, onDismiss: {
                   vm.kindEntities()
                   vm.entities()
               }) {
                   KindView()
               }
    }
    
    //  MARK: - Layout
    
    private var compact: some View {
        VStack(spacing: 0) {
            GroupedCalendarView(info: $vm.calendarInfo, dates: vm.dates)
                .dividerShadow()
                .floatShadow()
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            
            HStack {
                KindMenu(selectedKind: $vm.selectedKind, showKindMenuView: $vm.showKindMenuView, kinds: vm.kinds)
                
                Spacer()
                
                saveButton
            }
            .dividerShadow()
            .floatShadow()
            .padding(.bottom, 20).padding(.horizontal, 16)
            
            timetable
                .dividerShadow()
                .floatShadow()
        }
    }
    
    private var regular: some View {
        HStack(alignment: .top, spacing: 0) {
            GroupedCalendarView(info: $vm.calendarInfo, dates: vm.dates)
                .dividerShadow()
                .floatShadow()
                .frame(width: 320)
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            
            VStack(spacing: 0) {
                HStack {
                    KindMenu(selectedKind: $vm.selectedKind, showKindMenuView: $vm.showKindMenuView, kinds: vm.kinds)
                    
                    Spacer()
                    
                    saveButton
                }
                .dividerShadow()
                .floatShadow()
                .padding(.bottom, 20).padding(.horizontal, 16)
                
                timetable
                    .dividerShadow()
                    .floatShadow()
            }
        }
    }
    
    //  MARK: - Component
    
    private var header: some View {
        HStack(spacing: 0){
            Text("Timetable")
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
    
    private var timetable: some View {
        GeometryReader { geo in
            TimeTable(models: vm.items, tapColumn: vm.changeItemsByHour) { item, outIndex, inIndex in
                Group {
                    if let item = item {
                        Rectangle()
                            .fill(item.color.toPrimary().opacity(0.5))
                            .shadow(color: item.color.toPrimary().opacity(0.2), radius: 10, x: 0, y: 0)
                            .padding(.vertical, 5)
                            .frame(minHeight: 48)
                            .background(Divider(), alignment: .trailing)
                            .onTapGesture {
                                withAnimation(drawAnimation){
                                    if !vm.isModified {
                                        vm.isModified = true
                                    }
                                    vm.items[outIndex][inIndex] = nil
                                }
                            }
                    } else {
                        Color.clear
                            .frame(minHeight: 48)
                            .background(Divider(), alignment: .trailing)
                            .contentShape(Rectangle())
                            .onTapGesture{
                                withAnimation(drawAnimation){
                                    if !vm.isModified {
                                        vm.isModified = true
                                    }
                                    vm.items[outIndex][inIndex] = vm.selectedKind
                                }
                            }
                    }
                }
            }
            .frame(width: geo.size.width)
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            withAnimation(defaultAnimation) {
                vm.saveAndLoad()
                vm.isModified = false
            }
        }){
            Text("Save")
                .font(Font.system(.subheadline, design: .default).weight(.semibold))
                .padding(.horizontal, 28).padding(.vertical, 12)
                .background(Color.theme.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(vm.isModified ? Color.primary : Color.theme.dividerColor, lineWidth: vm.isModified ? 2 : 1)
                        .padding(vm.isModified ? 1 : 0.5)
                )
                .contentShape(Rectangle())
        }
        .opacity(vm.isModified ? 1 : 0.6)
        .disabled(!vm.isModified)
        .buttonStyle(InteractiveButtonStyle())
    }
}
