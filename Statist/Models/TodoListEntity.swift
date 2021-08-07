//
//  TodoListEntity.swift
//  Statist
//
//  Created by Kimyaehoon on 07/08/2021.
//

import SwiftUI

extension TodoListEntity: Comparable {
    public static func < (lhs: TodoListEntity, rhs: TodoListEntity) -> Bool {
        (lhs.name ?? "") > (rhs.name ?? "")
    }
}
