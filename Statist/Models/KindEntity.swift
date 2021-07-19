//
//  Kinds.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

extension KindEntity {
    var color: ColorKind {
        return ColorKind.string(name: self.colorKindID ?? "") ?? ColorKind.blue
    }
}
