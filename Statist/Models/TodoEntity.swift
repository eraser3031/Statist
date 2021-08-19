//
//  TodoListEntity.swift
//  Statist
//
//  Created by Kimyaehoon on 07/08/2021.
//

import SwiftUI

extension TodoEntity: Comparable {
    public static func < (lhs: TodoEntity, rhs: TodoEntity) -> Bool {
        (lhs.name ?? "") > (rhs.name ?? "")
    }
}
