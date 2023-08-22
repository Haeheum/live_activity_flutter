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
