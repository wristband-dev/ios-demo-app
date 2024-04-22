import SwiftUI
import SafariServices

struct AppLoginBrowserView: UIViewControllerRepresentable {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    // Function to create the SFSafariViewController instance
    func makeUIViewController(context: UIViewControllerRepresentableContext<AppLoginBrowserView>) -> SFSafariViewController {
        
        // Building the URL string using the required parameters
        if let appVanityDomain = authenticationViewModel.appVanityDomain,
           let clientId = authenticationViewModel.clientId {
            
            let urlString = "https://\(appVanityDomain)/login?client_id=\(clientId)"
            
            // Check if the URL is valid
            if let url = URL(string: urlString) {
                // If URL is valid, return a SFSafariViewController with the URL
                return SFSafariViewController(url: url)
            }
        }
        
        // Handle the invalid URL case by showing a blank SFSafariViewController or handling it in a better way
        let blankURL = URL(string: "about:blank")!
        let alertViewController = SFSafariViewController(url: blankURL)
        return alertViewController // Returning a blank SFSafariViewController to avoid app crash
    }
    
    // Required to conform to UIViewControllerRepresentable
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<AppLoginBrowserView>) {
    }
}
