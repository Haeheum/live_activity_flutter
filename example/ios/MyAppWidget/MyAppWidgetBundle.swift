//
//  MyAppWidgetBundle.swift
//  MyAppWidget
//
//  Created by hammizzang on 2023/08/14.
//

import WidgetKit
import SwiftUI

@main
struct MyAppWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyAppWidget()
        MyAppWidgetLiveActivity()
    }
}
