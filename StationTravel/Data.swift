//
//  Data.swift
//  StationTravel
//
//  Created by 亀川敦躍 on 2024/07/27.
//

import Foundation
import RealmSwift

class saveData: Object {
    @Persisted var point: Int = 0
    @Persisted var station: String = ""
    @Persisted var date: String
}
