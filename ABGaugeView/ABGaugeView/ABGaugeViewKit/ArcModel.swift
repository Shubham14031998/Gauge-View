//
//  AppDelegate.swift
//  ABGaugeView
//
//  Created by Shubham Kaliyar on 06/02/21.
//

import Foundation
import UIKit

struct ArcModel {
    var startAngle: CGFloat!
    var endAngle: CGFloat!
    var strokeColor: UIColor!
    var arcCap: CGLineCap!
    var center: CGPoint!
}
extension Array {
    mutating func rearrange(from: Int, to: Int) {
        precondition(from != to && indices.contains(from) && indices.contains(to), "invalid indexes")
        insert(remove(at: from), at: to)
    }
}
