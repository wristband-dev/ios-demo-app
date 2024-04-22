import SwiftUI

@main
struct iOS_Demo_App: App {
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LandingView()
                    .environmentObject(authenticationViewModel)
                    .onOpenURL { url in
                        Task {
                            await authenticationViewModel.handleRedirectUri(url: url)
                        }
                    }
            }
        }
    }
}
