import ActivityKit
import WidgetKit
import SwiftUI


let userDefaults = UserDefaults(suiteName: "group.kr.doubled.liveActivity")!

struct LiveActivityWidget: Widget {
    
    func getTeamName(number: Int) -> String {
        let teamDict = [1:"LANDERS", 2:"HEROES", 3:"TWINS", 4:"WIZ", 5:"TIGERS", 6:"DINOS", 7:"LIONS", 8:"GIANTS", 9:"BEARS", 10:"EAGLES"]
        
        return teamDict[number] ?? "SSG LANDERS"
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            let aTeam = context.state.aTeam ?? userDefaults.integer(forKey: "aTeam")
            let bTeam = context.state.bTeam ?? userDefaults.integer(forKey: "bTeam")
            let aTeamName = getTeamName(number: aTeam)
            let bTeamName = getTeamName(number: bTeam)
            let aScore = context.state.aScore ?? userDefaults.integer(forKey: "aScore")
            let bScore = context.state.bScore ?? userDefaults.integer(forKey: "bScore")
            
            let onLive = context.state.onLive ?? userDefaults.bool(forKey: "onLive")
            let gameStatus = context.state.gameStatus ?? userDefaults.string(forKey: "gameStatus")!
            
            
            ZStack {
                Rectangle()
                    .fill(Color.blue)
                    .cornerRadius(16)
                HStack(spacing:20){
                    Image("\(aTeam)")
                        .frame(width:51, height: 36)
                        .padding(.leading, 5)
                    VStack() {
                        Text(aTeamName)
                            .foregroundColor(Color.white)
                        Text("\(aScore)")
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 25))
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.teal)
                            .frame(height:30)
                        
                        HStack {
                            
                            Circle()
                                .fill(onLive ? Color.red : Color.black)
                                .frame(width: 8, height: 8)
                            
                            
                            Text(gameStatus)
                                .font(Font.system(size: 11, weight: .regular))
                                .foregroundColor(Color.white)
                            
                            
                        }
                        .padding(.horizontal, 7)
                    }
                    
                    .frame( width: 100,height:30)
                    
                    
                    VStack() {
                        Text(bTeamName)
                            .foregroundColor(Color.white)
                        Text("\(bScore)")
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 25))
                    }
                    Image("\(bTeam)")
                        .frame(width:51, height: 36)
                        .padding(.trailing, 5)
                }
            }
            .frame(height:82)
        } dynamicIsland: { context in
            return  DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    
                    
                }
            } compactLeading: {
                
            } compactTrailing: {
                
            } minimal: {
                
            }
        }
    }
}
