import Flutter
import UIKit
import ActivityKit

public class LiveActivityFlutterPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var activityEventSink: FlutterEventSink?
    private var appGroupId: String?
    private var userDefaults: UserDefaults?
    private var liveActivityIds = [String]()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "liveActivity", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "onActivityChange", binaryMessenger: registrar.messenger())
        
        let instance = LiveActivityFlutterPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
        registrar.addApplicationDelegate(instance)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if let args = arguments as? String{
            if (args == "onActivityChange") {
                activityEventSink = events
            }
        }
        return nil
    }
    
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        if let args = arguments as? String{
            if (args == "onActivityChange") {
                self.activityEventSink = nil
            }
        }
        return nil
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "isActivitySupported"){
            if #available(iOS 16.1, *) {
                result(true)
            } else {
                result(false)
            }
            return
        }
        if #available(iOS 16.1, *) {
            if(call.method == "init"){
                guard let args = call.arguments as? [String: Any] else {return}
                guard let appGroupId = args["appGroupId"] as? String else {return}
                self.appGroupId = appGroupId
                userDefaults = UserDefaults(suiteName: self.appGroupId)!
                result(nil)
                
            }else if(call.method == "isActivityExecutable"){
                result(ActivityAuthorizationInfo().areActivitiesEnabled)
                
            }else if(call.method == "createActivity"){
                guard let args = call.arguments as? [String: Any] else {return}
                let data = args["data"] as? [String: Any]
                let durationSumInMinutes = args["durationSumInMinutes"]as? Int ?? nil;
                let relevanceScore = args["relevanceScore"] as? Double ?? 0.0;
                
                createActivity(data: data, durationSumInMinutes: durationSumInMinutes, relevanceScore: relevanceScore, result: result)
                
            }else if(call.method == "updateActivity"){
                guard let args = call.arguments as? [String: Any] else {return}
                let activityId = (args["activityId"] as? String)!
                let data = args["data"] as? [String: Any] ?? nil
                let alert = (args["alert"] as? Bool)!
                let alertTitle = args["alertTitle"] as? String ?? nil
                let alertBody = args["alertBody"] as? String ?? nil
                
                if(alert){
                    updateActivity(activityId: activityId, data: data, alertTitle: alertTitle, alertBody: alertBody, result: result)
                } else{
                    updateActivity(activityId: activityId, data: data, result: result)
                }
                
                
            }else if(call.method == "endActivity"){
                guard let args = call.arguments as? [String: Any] else {return}
                let activityId = (args["activityId"] as? String)!
                
                endActivity(activityId: activityId, result: result)
                
            }else if(call.method == "endAllActivities"){
                endAllActivities(result: result)
                
            }else if(call.method == "getActivityState"){
                guard let args = call.arguments as? [String: Any] else {return}
                let activityId = (args["activityId"] as? String)!
                
                getActivityState(activityId: activityId, result: result)
            }
            return
        } else{
            result(FlutterError(code: "NOT_SUPPORTED", message: "Live Activity is not supported on current device.", details: nil))
        }
        
    }
    
    @available(iOS 16.1, *)
    func createActivity(data: [String: Any]?, durationSumInMinutes: Int?, relevanceScore: Double, result: @escaping FlutterResult){
        if(data != nil){
            for item in data! {
                userDefaults!.set(item.value, forKey: item.key)
            }
        }
        
        let liveActivityAttributes = LiveActivityAttributes()
        let initialContentState = LiveActivityAttributes.DynamicData()
        var initialActivity: Activity<LiveActivityAttributes>
        if #available(iOS 16.2, *){
            let initialContent = ActivityContent(
                state: initialContentState,
                staleDate: durationSumInMinutes == nil ? nil: Calendar.current.date(byAdding: .minute, value: durationSumInMinutes!, to: Date.now)
            )
            do{
                initialActivity = try Activity<LiveActivityAttributes>.request(
                    attributes: liveActivityAttributes,
                    content: initialContent,
                    pushType: .token)
                watchActivity(initialActivity)
                result(initialActivity.id)
                
            }catch(let error){
                result(FlutterError(code: "LIVE_ACTIVITY_ERROR", message: "failed creating live activity", details: error.localizedDescription))
                
            }
        } else{
            do{
                initialActivity = try Activity<LiveActivityAttributes>.request(
                    attributes: liveActivityAttributes,
                    contentState: initialContentState,
                    pushType: .token)
                
                
                watchActivity(initialActivity)
                result(initialActivity.id)
            }catch(let error){
                result(FlutterError(code: "LIVE_ACTIVITY_ERROR", message: "failed creating live activity", details: error.localizedDescription))
            }
        }
    }
    
    @available(iOS 16.1, *)
    func updateActivity(activityId: String, data: [String: Any]?, alertTitle: String? = nil, alertBody: String? = nil, result: @escaping FlutterResult) {
        Task {
            for activity in Activity<LiveActivityAttributes>.activities {
                if activityId == activity.id {
                    if(data != nil){
                        for item in data! {
                            userDefaults!.set(item.value, forKey: item.key)
                        }
                    }
                    var alertConfiguration: AlertConfiguration?
                    if(alertTitle != nil){
                        alertConfiguration = AlertConfiguration(title: LocalizedStringResource("\(alertTitle!)"), body:LocalizedStringResource("\(alertBody!)"), sound: AlertConfiguration.AlertSound.default)
                    }
                    let emptyContentState = LiveActivityAttributes.DynamicData()
                    if #available(iOS 16.2, *){
                        let emptyContent = ActivityContent(
                            state: emptyContentState,
                            staleDate: nil)
                        await activity.update(emptyContent, alertConfiguration: alertConfiguration)
                    } else {
                        await activity.update(using: emptyContentState, alertConfiguration: alertConfiguration)
                    }
                    
                    
                    
                    break;
                }
            }
            result(nil)
        }
    }
    
    @available(iOS 16.1, *)
    func endActivity(activityId: String, result: @escaping FlutterResult) {
        Task {
            for activity in Activity<LiveActivityAttributes>.activities {
                if (activity.id == activityId) {
                    await activity.end(dismissalPolicy: .immediate)
                }
            }
        }
    }
    
    @available(iOS 16.1, *)
    func endAllActivities(result: @escaping FlutterResult) {
        Task {
            for activity in Activity<LiveActivityAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }
            result(nil)
        }
    }
    
    @available(iOS 16.1, *)
    func getActivityState(activityId: String, result: @escaping FlutterResult) {
        Task {
            for activity in Activity<LiveActivityAttributes>.activities {
                if (activityId == activity.id) {
                    switch (activity.activityState) {
                    case .active:
                        result("active")
                    case .stale:
                        result("stale")
                    case .ended:
                        result("ended")
                    case .dismissed:
                        result("dismissed")
                    default:
                        result("dismissed")
                    }
                }
            }
        }
    }
    
    @available(iOS 16.1, *)
    private func watchActivity<T : ActivityAttributes>(_ activity: Activity<T>) {
        Task {
            for await state in activity.activityStateUpdates {
                print("activityUpdate")
                var response: Dictionary<String, Any> = Dictionary()
                response["activityId"] = activity.id
                response["pushToken"] = ""
                if(state == .active){
                    response["liveActivityState"] = "active"
                    print(activity.pushTokenUpdates)
                    for await data in activity.pushTokenUpdates {
                        let pushToken = data.map {String(format: "%02x", $0)}.joined()
                        response["pushToken"] = pushToken
                        activityEventSink?.self(response)
                    }
                }else if(state == .ended){
                    response["liveActivityState"] = "ended"
                    activityEventSink?.self(response)
                }else if (state == .dismissed){
                    response["liveActivityState"] = "dismissed"
                    activityEventSink?.self(response)
                }else{
                    response["liveActivityState"] = "stale"
                    activityEventSink?.self(response)
                }
            }
        }
    }
    
    struct LiveActivityAttributes: ActivityAttributes, Identifiable{
        public typealias DynamicData = ContentState
        public struct ContentState: Codable, Hashable {
            
        }
        
        var id = UUID()
    }
}
