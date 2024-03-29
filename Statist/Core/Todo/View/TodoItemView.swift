//
//  TodoItemView.swift
//  Statist
//
//  Created by Kimyaehoon on 07/07/2021.
//

import SwiftUI
import Combine

struct TodoItemView: View {
    @Environment(\.colorScheme) var colorScheme
    let model: TodoEntity
    @ObservedObject var vm: TodoViewModel
    
    let primaryColor: Color
    
    let defaultAnimation = Animation.closeCard
    
    init(_ model: TodoEntity, vm: TodoViewModel) {
        self.model = model
        self.vm = vm
        self.primaryColor = model.kindEntity?.color.primary() ?? .primary
    }
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: model.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.callout)
                Text(model.name ?? "")
                    .font(Font.system(.footnote, design: .default).weight(.medium))
                
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.openCard) {
                    vm.toggle(model)
                }
            }

            Menu {
                Button(action: {
                    withAnimation(defaultAnimation) {
                        vm.changeTaskToEdit(model)
                    }
                }) {
                    Label("Edit", systemImage: "pencil")
                }
                
                Button(action: {
                    withAnimation(defaultAnimation) {
                        vm.moveBackDate(model)
                    }
                }) {
                    Label("Move back the date", systemImage: "calendar.badge.clock")
                }
                
                Divider()
                
                Button(action: {
                    withAnimation(defaultAnimation) {
                        vm.deleteEntity(entity: model)
                    }
                }) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.headline)
                    .foregroundColor(Color(.systemGray))
                    .padding(5).padding(.horizontal, 2)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.theme.subBackgroundColor)
                    )
                    .padding(2)
            }
        }
        .foregroundColor(model.isDone ? primaryColor : .primary )
        .padding(12)
        .padding(.vertical, model.isDone ? 0 : 3)
        .background(Color.theme.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.theme.dividerColor))
//        .background(colorScheme == .dark ? Color.theme.itemBackgroundColor : Color.theme.backgroundColor)
//        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
//        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.theme.dividerColor))
        .contentShape(Rectangle())
        .animation(defaultAnimation)
    }
}

extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}
