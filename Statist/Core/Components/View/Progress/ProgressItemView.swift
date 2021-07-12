//
//  ProgressItemView.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct ProgressItemView: View {
    @Binding var model: ProgressModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            
            HStack(spacing: 6){
                Text(model.name)
                    .font(Font.system(.headline, design: .default).weight(.bold))
                    .lineLimit(1)
                
                Text(model.kind.name)
                    .font(Font.system(.headline, design: .default).weight(.semibold))
                    .lineLimit(1)
                    .foregroundColor(model.kind.color.toPrimary())
            }
            
            //
            
            HStack(spacing: 6){
                Text("\(model.percentage, specifier: "%.2f")")
                
                Text("\(model.now)/\(model.goal)")
                
                Spacer()
                
                Button(action: minus) {
                    Text("-")
                }
                
                Button(action: plus) {
                    Text("+")
                }
            }
        }
        
    }
    
    func plus(){
        
    }
    
    func minus(){
        
    }
}

//struct ProgressItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressItemView(model: .constant(Proj))
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}
