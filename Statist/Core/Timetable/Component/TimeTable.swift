//
//  TimeTable.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

struct TimeTable<ItemView>: View where ItemView: View {
    
    let items: [[KindEntity?]]
    let tapColumn: (Int) -> Void
    let content: (KindEntity?, Int, Int) -> ItemView
    
    init(
        models: [[KindEntity?]],
        tapColumn: @escaping (Int) -> Void,
        @ViewBuilder content: @escaping (KindEntity?, Int, Int) -> ItemView
    ) {
        self.items = models
        self.tapColumn = tapColumn
        self.content = content
    }

    var body: some View {
//        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section(header: TimeTableHeader()) {
                        HStack(spacing: 1){
                            TimeTableColumn(tapColumn: tapColumn)
                            LazyVStack(spacing: 1){
                                ForEach(0..<items.count){ index in
                                    TimeTableRow(index: index, models: items[index], content: self.content)
                                        .id(index)
                                }
                            }
                        }
                    }
                }
                .padding(1)
                .background(Color.theme.dividerColor)
                .padding(.horizontal, 16)
//            }
//            .onAppear {
//                proxy.scrollTo(12, anchor: .center)
//            }
        }
    }
}


