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
    @State var testText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.kinds) { kind in
                    let name = kind.name ?? ""
                    let primaryColor = kind.color.primary()
                    
                    NavigationLink(destination: KindTaskView(kind, kinds: vm.kinds, save: {
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
            .background(
                NavigationLink(destination: KindTaskView(nil, kinds: vm.kinds, save: {
                    vm.save()
                })
                , isActive: $vm.showKindTaskView) {
                    EmptyView()
                }
            )
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Cancel")
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
        }
        .accentColor(.primary)
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
        Button(action: {
            vm.showKindTaskView = true
        }) {
            Image(systemName: "plus")
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    //  MARK: - method
    
    private func delete(at offsets: IndexSet) {
        if let first = offsets.first {
            vm.kinds.remove(at: first)
        }
    }
}

