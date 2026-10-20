import SwiftUI

#if !SWIFT_PACKAGE
@main
#endif
public struct LarisOSApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
