//
//  MyAppWidgetBundle.swift
//  MyAppWidget
//
//  Created by hammizzang on 2023/08/14.
//

import WidgetKit
import SwiftUI

@main
struct LiveActivityBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16, *) {
            LiveActivityWidget()
        }
    }
}
