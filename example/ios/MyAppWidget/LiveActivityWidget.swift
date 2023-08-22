import ActivityKit
import WidgetKit
import SwiftUI


let userDefaults = UserDefaults(suiteName: "group.kr.doubled.liveActivity")!

struct LiveActivityWidget: Widget {
    
    func getTeamName(number: Int) -> String {
        let teamDict = [1:"SSG LANDERS", 2:"KIWOOM HEROES", 3:"LG TWINS", 4:"KT WIZ", 5:"KIA TIGERS", 6:"NC DINOS", 7:"SAMSUNG LIONS", 8:"LOTTE GIANTS", 9:"DOOSAN BEARS", 10:"HANWHA EAGLES"]
        
        return teamDict[number] ?? ""
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
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                HStack(spacing:20){
                    Image("\(aTeam)")
                        .frame(width:51, height: 36)
                    VStack() {
                        Text(aTeamName)
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 12, weight: .regular))
                        Text("\(aScore)")
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 30, weight: .regular))
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray)
                            .frame(height:30)
                        
                        HStack {
                            
                            HStack {
                                if(onLive){
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 4, height: 4)
                                }else{
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 4, height: 4)
                                }
                                
                                Text(gameStatus)
                                    .font(Font.system(size: 11, weight: .regular))
                                    .foregroundColor(Color.white)
                            }
                            
                        }
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                    }
                    
                    .frame( width: 100,height:30)
                    
                    
                    VStack() {
                        Text(bTeamName)
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 12, weight: .regular))
                        Text("\(bScore)")
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 30, weight: .regular))
                    }
                    Image("\(bTeam)")
                        .frame(width:51, height: 36)
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

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
