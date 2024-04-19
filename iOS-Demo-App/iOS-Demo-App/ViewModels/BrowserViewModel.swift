import Foundation

@MainActor
class BrowserViewModel: ObservableObject {
    
    @Published var showBrowser = false
    
    func handleURL(_ url: URL) {
        guard url.scheme == "demoapp" else {
            return
        }
        self.showBrowser = false
        print("Received URL: \(url)")
    }
}
