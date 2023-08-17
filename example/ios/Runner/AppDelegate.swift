import UIKit
import Flutter
import nb_navigation_flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        customStyle()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func customStyle() {
        customDayStyle.arrivalTimeLabelFont = UIFont.systemFont(ofSize: 28, weight: .medium).adjustedFont
        customDayStyle.trafficUnknownColor = UIColor.red
        customDayStyle.nextBannerViewBackgroundColor = #colorLiteral(red: 0.7843137255, green: 0.3058823529, blue: 0.05098039216, alpha: 1)
        customDayStyle.maneuverNextBannerPrimaryColor = #colorLiteral(red: 0.6196078431, green: 0.06274509804, blue: 1, alpha: 1)
        customDayStyle.mapStyleURL = URL(string: "https://api.nextbillion.io/tt/style/1/style/22.2.1-9?map=2/basic_street-light")!
        

        
        customNightStyle.trafficUnknownColor = UIColor.green
        customNightStyle.mapStyleURL = URL(string: "https://api.nextbillion.io/tt/style/1/style/22.2.1-9?map=2/basic_street-dark")!
    }
}
