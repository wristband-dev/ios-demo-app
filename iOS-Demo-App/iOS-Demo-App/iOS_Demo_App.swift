import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UIBarButtonItem.appearance().tintColor = CustomColors.invoBlueUIColor
        return true
    }
}


@main
struct iOS_Demo_App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @StateObject var usersViewModel = UsersViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack (path: $authenticationViewModel.path) {
                AuthenticationView()
            }
            .onOpenURL { url in
                Task {
                    await authenticationViewModel.handleRedirectUri(url: url)
                }
            }
        }
        .environmentObject(authenticationViewModel)
        .environmentObject(usersViewModel)
        
    }
}
