//
//  GoalSheetView.swift
//  Statist
//
//  Created by Kimyaehoon on 22/08/2021.
//

import SwiftUI

struct GoalSheetView: View {
    
    @Binding var entity: GoalEntity?
    let front: () -> Void
    let back: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(entity?.name ?? "")
                
                Spacer()
                
                //닫기 버
            }
            
        }
    }
}

//struct GoalSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalSheetView()
//    }
//}
