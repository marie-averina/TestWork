//
//  Date + Ext.swift
//  TemplateOfDealsViewer
//
//  Created by Мария Аверина on 22.02.2023.
//

import Foundation

extension Date {
    func getString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: self)
    }
}
