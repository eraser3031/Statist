//
//  KindListView.swift
//  Statist
//
//  Created by Kimyaehoon on 11/08/2021.
//

import SwiftUI

struct KindView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm = KindViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.kinds) { kind in
                    let name = kind.name ?? ""
                    let primaryColor = kind.color.toPrimary()
                    
                    NavigationLink(destination: TaskKindView(kind, kinds: vm.kinds, save: {
                        vm.save()
                    })) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(primaryColor)
                                .frame(width: 10, height: 10)
                            
                            Text(name)
                                .font(Font.system(.subheadline, design: .default).weight(.semibold))
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationBarTitle("Kinds", displayMode: .inline)
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    cancelButton
//                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            UIApplication.shared.endEditing()
        }
    }
    
    //  MARK: - components
    
    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
        }
    }
    
    private var addButton: some View {
        NavigationLink(destination: TaskKindView(nil, kinds: vm.kinds, save: {
            vm.save()
        })) {
            Image(systemName: "plus")
        }
    }
    
    //  MARK: - method
    
    private func delete(at offsets: IndexSet) {
        if let first = offsets.first {
            vm.kinds.remove(at: first)
        }
    }
}

