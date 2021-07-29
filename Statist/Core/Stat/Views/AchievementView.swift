//
//  AchievementView.swift
//  Statist
//
//  Created by Kimyaehoon on 25/07/2021.
//

import SwiftUI

struct AchievementView: View {
    
    @ObservedObject var vm: StatViewModel
    
    init(model: StatViewModel) {
        self.vm = model
    }
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Achievement")
                        .font(Font.system(.footnote, design: .default).weight(.bold))
                        .foregroundColor(Color(.systemGray3))
                    
                    Text("\(vm.percent)%")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Prev Week")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray3))
                    
                    HStack{
                        Text("\(vm.percentGap)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(vm.countGap)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            
            Spacer()
            
            CircleChart(percent: vm.percent, colors: [Color.primary])
            
        }
        .padding(20)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(.systemGray5))
        )
        .frame(height: 150)
    }
}

//struct AchievementView_Previews: PreviewProvider {
//    static var previews: some View {
//        AchievementView()
//    }
//}

 
