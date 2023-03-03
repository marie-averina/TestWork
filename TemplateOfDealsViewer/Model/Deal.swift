//
//  Deal.swift
//  TemplateOfDealsViewer
//
//  Created by Мария Аверина on 03.03.2023.
//

import Foundation

struct Deal {
    let id: Int64
    let dateModifier: Date
    let instrumentName: String
    let price: Double
    let amount: Double
    let side: Side
  
    enum Side: CaseIterable {
        case sell, buy
    }
}
