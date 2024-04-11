//
//  UIView+Extension.swift
//  PuDingProj
//
//  Created by cho on 4/11/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
