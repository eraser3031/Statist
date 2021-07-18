//
//  TimeTable.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

struct TimeTable: View {
    
    let selectedKind: Kind?
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 1), count: 7)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            LazyVStack(spacing: 1, pinnedViews: [.sectionHeaders]) {
                Section(header: TimeTableHeader()) {
                    HStack(spacing: 1){
//                        TimeTableColumn()
                        LazyVStack(spacing: 1){
                            ForEach(0..<25){ _ in
                                TimeTableRow(selectedKind)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], 1)
            .background(Color.theme.dividerColor)
            .padding()
            .frame(width: UIScreen.main.bounds.width)
            
        }
    }
}

//struct TimeTable_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeTable()
////            .preferredColorScheme(.dark)
//    }
//}


struct AlterTimeTable<ItemView>: View where ItemView: View {
    
    typealias indexes = (out: Int, in: Int)
    
    let items: [[Kind?]]
    let tapColumn: (Int) -> Void
    let content: (indexes) -> ItemView
    
    init(
        items: [[Kind?]],
        tapColumn: @escaping (Int) -> Void,
        @ViewBuilder content: @escaping (indexes) -> ItemView
    ) {
        self.items = items
        self.tapColumn = tapColumn
        self.content = content
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section(header: TimeTableHeader()) {
                    HStack(spacing: 0){
                        TimeTableColumn(tapColumn: tapColumn)
                        LazyVStack(spacing: 0){
                            ForEach(0..<items.count){ index in
                                AlterTimeTableRow(index: index, items: items[index], content: self.content)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], 1)
            .background(Color(.systemBackground))
            .padding()
            .frame(width: UIScreen.main.bounds.width)
            
        }

    }
}


