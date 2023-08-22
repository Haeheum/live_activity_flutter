import ActivityKit
import WidgetKit
import SwiftUI


let userDefaults = UserDefaults(suiteName: "group.kr.doubled.liveActivity")!

struct LiveActivityWidget: Widget {
    
    func getBase(value: Int) -> (Bool, Bool, Bool) {
        var arr: [Bool] = [false, false, false]
        if value >= 0 && value <= 7 {
            let bin = String(format: "%03d", Int(String(value, radix: 2))!)
            var i = 0 ;
            for char in bin {
                arr[i] = char == "0" ? false : true;
                i += 1
            }
        }
        return (arr[0], arr[1],arr[2])
    }
    
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
            let base = context.state.base ?? userDefaults.integer(forKey: "base")
            let (isBaseThree, isBaseTwo, isBaseOne) = getBase(value: base)
            let outCount = context.state.outCount ?? userDefaults.integer(forKey: "outCount")
            

            ZStack {
                Rectangle()
                    .fill(Color.black)
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
                            .fill(Color(red: 0.106, green: 0.106, blue: 0.106))
                            .frame(height:30)
                        
                        HStack {
                            
                            HStack {
                                if(onLive){
                                    Circle()
                                        .fill(Color(red: 0.867, green: 0.155, blue: 0.155))
                                        .frame(width: 4, height: 4)
                                }else{
                                    Circle()
                                        .fill(Color(red: 0.242, green: 0.242, blue: 0.242))
                                        .frame(width: 4, height: 4)
                                }
                                
                                Text(gameStatus)
                                    .font(Font.system(size: 11, weight: .regular))
                                    .foregroundColor(Color.white.opacity(0.8))
                            }
                            VStack (alignment: .center) {
                                VStack(spacing: 0){
                                    //2루
                                    Rectangle()
                                        .frame(width: 7, height: 7)
                                        .foregroundColor(isBaseTwo ? Color.white : Color(red: 0.242, green: 0.242, blue: 0.242))
                                        .transformEffect(CGAffineTransform(rotationAngle: .pi / 4))
                                    
                                    HStack (spacing:4){
                                        //3루
                                        Rectangle()
                                            .frame(width: 7, height: 7)
                                            .foregroundColor(isBaseThree ? Color.white : Color(red: 0.242, green: 0.242, blue: 0.242))
                                            .transformEffect(CGAffineTransform(rotationAngle: .pi / 4))
                                        //1루
                                        Rectangle()
                                            .frame(width: 7, height: 7)
                                            .foregroundColor(isBaseOne ? Color.white : Color(red: 0.242, green: 0.242, blue: 0.242))
                                            .transformEffect(CGAffineTransform(rotationAngle: .pi / 4))
                                    }
                                }
                                .padding(.leading, 7)
                                HStack(spacing: 2){
                                    Circle()
                                        .fill(outCount > 0 ? Color(red: 0.867, green: 0.155, blue: 0.155) : Color(red: 0.242, green: 0.242, blue: 0.242) )
                                        .frame(width: 4, height: 4)
                                    Circle()
                                        .fill(outCount > 1 ? Color(red: 0.867, green: 0.155, blue: 0.155) : Color(red: 0.242, green: 0.242, blue: 0.242 ))
                                        .frame(width: 4, height: 4)
                                }
                            }
                            .frame(height:23)
                            
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
