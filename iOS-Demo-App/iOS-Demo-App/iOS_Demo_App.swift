import SwiftUI

@main
struct iOS_Demo_App: App {
    @StateObject var browserViewModel = BrowserViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(browserViewModel)
                .onOpenURL { url in
                    browserViewModel.handleURL(url)
                }
        }
    }
}
