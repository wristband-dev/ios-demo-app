import SwiftUI

@main
struct iOS_Demo_App: App {
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @StateObject var usersViewModel = UsersViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LandingView()
            }
            .environmentObject(authenticationViewModel)
            .environmentObject(usersViewModel)
            .onOpenURL { url in
                Task {
                    await authenticationViewModel.handleRedirectUri(url: url)
                }
            }
        }
    }
}
