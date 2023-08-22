import Foundation
import ActivityKit

struct LiveActivityAttributes: ActivityAttributes, Identifiable{
    public typealias DynamicData = ContentState
    public struct ContentState: Codable, Hashable {

        var aTeam: Int?
        var bTeam: Int?
        var aScore: Int?
        var bScore: Int?
        var onLive: Bool?
        var gameStatus: String?
        var base: Int?
        var outCount: Int?

    }
    
    var id = UUID()
}
