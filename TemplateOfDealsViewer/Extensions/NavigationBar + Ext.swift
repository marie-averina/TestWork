//
//  NavigationBar + Ext.swift
//  TemplateOfDealsViewer
//
//  Created by Мария Аверина on 23.02.2023.
//

import UIKit

extension UINavigationBar {
    func hideHairline() {
        standardAppearance.shadowColor = nil
        standardAppearance.shadowImage = nil
    }
    
    func restoreHairline() {
        standardAppearance.shadowColor = .separator
    }
}
