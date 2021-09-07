//
//  InfoView.swift
//  Statist
//
//  Created by Kimyaehoon on 30/08/2021.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var infoVM: InfoViewModel
    @StateObject var settingVM = SettingViewModel()
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ZStack {
                        Color(UIColor.systemGroupedBackground)
                        
                        VStack {
                            ZStack(alignment: .bottomTrailing) {
                                Image(uiImage: UIImage(data: infoVM.info?.thumbnail ?? Data() ) ?? UIImage(named: "TempThumbnail")! )
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 128, height: 128)
                                    .clipShape(Circle())
                                
                                Circle()
                                    .fill(Color.theme.groupItemBackgroundColor)
                                    .frame(width: 48, height: 48)
                                    .dividerShadow()
                                    .overlay(Image(systemName: "photo"))
                                    .onTapGesture {
                                        showImagePicker = true
                                    }
                            }
                            
//                            Text(infoVM.info?.name ?? "Write Your Name")
//                                .font(.headline)
//                                .multilineTextAlignment(.center)
//                                .padding(.top)
                        }
                    }
                    .listRowBackground(Color(UIColor.systemGroupedBackground))
                }
                
                Section {
                    NavigationLink(destination: AppInfoView()) {
                        Label("App Info", systemImage: "info.circle.fill")
                    }
                }
                
                Section {
                    Label("Remove All Data", systemImage: "trash.fill")
                        .foregroundColor(.red)
                        .onTapGesture {
                            showDeleteAlert = true
                        }
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(title: Text("Remove All Data"),
                                  message: Text("All data will be deleted. Do you really want to delete it??"),
                                  primaryButton: .cancel(),
                                  secondaryButton: .destructive(Text("Delete All"), action: {
                                    settingVM.clearAll()
                                  })
                            )
                        }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Cancel")
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
            }
        }
        .accentColor(.primary)
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        infoVM.updateThumbnail(inputImage.jpegData(compressionQuality: 0.5) ?? Data())
    }
}

//struct InfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        InfoView()
//    }
//}

