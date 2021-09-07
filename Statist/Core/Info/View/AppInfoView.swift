//
//  AppInfoView.swift
//  Statist
//
//  Created by Kimyaehoon on 07/09/2021.
//

import SwiftUI

struct AppInfoView: View {
    var body: some View {
        
        VStack {
            Spacer()
                .frame(height: 80)
            Image("AppIconInApp")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            Text("Statist")
                .font(.title3).bold()
            Text("1.0.0")
                .foregroundColor(.gray)
                .font(.footnote).bold()
            Spacer()
        }
        .navigationBarTitle("App Info")
    }
}

struct AppInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppInfoView()
    }
}
