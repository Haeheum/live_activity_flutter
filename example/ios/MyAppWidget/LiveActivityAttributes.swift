import Foundation
import ActivityKit

struct LiveActivityAttributes: ActivityAttributes, Identifiable{
    public typealias DynamicData = ContentState
    public struct ContentState: Codable, Hashable {

        var aTeamName: String?
        var bTeamName: String?
        var aScore: Int?
        var bScore: Int?
        var onLive: Bool?
        var gameStatus: String?
    }
    
    var id = UUID()
}
