//
//  TTItemModel.swift
//  Statist
//
//  Created by Kimyaehoon on 19/07/2021.
//

import Foundation

struct TTItemModel: Identifiable {
    let id: String = UUID().uuidString
    var outIndex: Int
    var inIndex: Int
    var kindEntity: KindEntity?
    
    init(_ outIndex: Int, _ inIndex: Int, kind: KindEntity?) {
        self.outIndex = outIndex
        self.inIndex = inIndex
        self.kindEntity = kind
    }
}
