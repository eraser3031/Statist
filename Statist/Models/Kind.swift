//
//  Kinds.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

struct Kind: Identifiable {
    let id = UUID().uuidString
    var name: String
    var colorKind: ColorKind
}
