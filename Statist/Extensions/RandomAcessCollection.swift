//
//  RandomAcessCollection.swift
//  Statist
//
//  Created by Kimyaehoon on 11/07/2021.
//

import Foundation

extension RandomAccessCollection {
    func indexed() -> Array<(offset: Int, element: Element)> {
    Array(enumerated())
    }
}
