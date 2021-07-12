//
//  TimeTable.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

struct TimeTable: View {
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 1), count: 7)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 1) {
                TimeTableRow()
                HStack(spacing: 0){
                    TimeTableColumn()
                    LazyVStack(spacing: 1){
                        
                        ForEach(0..<25){ _ in
                            TimeTableItem()
                        }
                    }
                }
            }
            .padding(1)
            .background(Color.theme.dividerColor)
            .padding()
            .frame(width: UIScreen.main.bounds.width)
            
        }
    }
}

struct TimeTable_Previews: PreviewProvider {
    static var previews: some View {
        TimeTable()
//            .preferredColorScheme(.dark)
    }
}


//struct TimeTable: View {
//
//    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 1), count: 7)
//
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            LazyVGrid(columns: columns,
//                      alignment: .center,
//                      spacing: 1,
//                      pinnedViews: []) {
//                ForEach((0..<(7*25)), id: \.self) { _ in
//                    TimeTableItem(kind: nil)
//                }
//            }
//            .padding(1)
//            .background(Color.theme.dividerColor)
//            .padding()
//            .frame(width: UIScreen.main.bounds.width)
//
//        }
//    }
//}


