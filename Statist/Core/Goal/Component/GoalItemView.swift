//
//  GoalItemView.swift
//  Statist
//
//  Created by Kimyaehoon on 22/08/2021.
//

import SwiftUI

struct GoalItemView: View {
    let entity: GoalEntity
    @ObservedObject var vm: GoalViewModel
    @State var showAlert = false
    
    var isFinish: Bool {
        entity.endDate ?? Date().toDay < Date().toDay
    }
    
    let defaultAnimation = Animation.closeCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                HStack(spacing: 4) {
                    Circle()
                        .fill(entity.kindEntity?.color.primary() ?? Color.primary)
                        .frame(width: 8, height: 8)
                    
                    Text(entity.kindEntity?.name ?? "Kind")
                        .font(Font.system(.caption, design: .default).weight(.bold))
                }
                .padding(.horizontal, 10).padding(.vertical, 5)
                .overlay(Capsule().stroke(Color.theme.dividerColor))
                
                Text("~ \(entity.endDate?.string() ?? "∞")")
                    .font(Font.system(.caption, design: .default).weight(.bold))
                    .foregroundColor(Color(.darkGray))
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color.theme.subBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Spacer()
                
                if entity.isFinish {
                    Circle()
                        .fill(entity.kindEntity?.color.primary() ?? .primary)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(Font.system(.footnote, design: .default).weight(.semibold))
                                .foregroundColor(Color.theme.backgroundColor)
                        )
                }
                
                Menu {
                    Button(action: {
                        withAnimation(defaultAnimation){
                            vm.editingEntity = entity
                            vm.taskCase = .edit
                        }
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Divider()
                    
                    Button(action: {
                        showAlert = true
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Circle()
                        .fill(Color.theme.itemBackgroundColor)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "ellipsis")
                                .font(Font.system(.footnote, design: .default).weight(.medium))
                                .foregroundColor(.gray)
                        )
                }
                .alert(isPresented: $showAlert) {
                    
                    Alert(title: Text("Delete Goal"),
                          message: Text("Do you want to delete the goal?"),
                          primaryButton: .destructive(Text("Delete"), action: {
                                withAnimation(defaultAnimation) {
                                    vm.deleteEntity(entity: entity)
                                }
                            }),
                          secondaryButton: .cancel(Text("Cancel")))
                }

            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(entity.name ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("\(entity.now) / \(Int(entity.goal))")
                    .font(Font.system(.title3, design: .default).weight(.heavy))
                    .italic()
                    .minimumScaleFactor(0.1)
            }
            
            HStack(spacing: 8) {
                Capsule()
                    .fill(Color.theme.dividerColor)
                    .frame(maxWidth: .infinity).frame(height: 2)
                    .overlay(
                        GeometryReader { geo in
                            Capsule()
                                .fill(entity.kindEntity?.color.primary() ?? Color.primary)
                                .frame(width: geo.size.width * entity.percentForCalcurate, height: 2, alignment: .leading)
                        }
                    )
                
                Text("\(entity.percent)%")
                    .minimumScaleFactor(0.9)
                    .font(.caption)
                    .foregroundColor(Color.gray)
            }
            
            
            if vm.selectedEntity == entity {
                HStack(spacing: 10) {
                    Button(action: {
                        withAnimation(defaultAnimation){
                            vm.backward()
                        }
                    }) {
                        Label("Backward", systemImage: "arrow.uturn.backward")
                            .font(Font.system(.footnote, design: .default).weight(.semibold))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(Color.theme.groupBackgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color.theme.dividerColor)
                            )
                    }
                    
                    Button(action: {
                        withAnimation(defaultAnimation) {
                            vm.proceed()
                        }
                    }) {
                        Label("Proceed", systemImage: "arrow.forward")
                            .font(Font.system(.footnote, design: .default).weight(.semibold))
                            .foregroundColor(Color.theme.backgroundColor)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(Color.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                }
            }
            
        }
        .padding(16)
        .background(
            Color.theme.backgroundColor
                .onTapGesture {
                if !isFinish {
                        withAnimation(defaultAnimation){
                            vm.selectedEntity = entity
                        }
                    }
                }
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.theme.dividerColor))
        .grayscale(isFinish ? 1 : 0)
        .opacity(isFinish ? 0.5 : 1)
        
    }
}

//struct GoalItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalItemView()
//    }
//}
