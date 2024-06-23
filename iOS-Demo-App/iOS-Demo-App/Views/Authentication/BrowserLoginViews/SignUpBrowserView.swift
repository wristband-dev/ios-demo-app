import SwiftUI
import SafariServices

struct SignUpBrowserView: UIViewControllerRepresentable {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    // Function to create the SFSafariViewController instance
    func makeUIViewController(context: UIViewControllerRepresentableContext<SignUpBrowserView>) -> SFSafariViewController {
        
        // Building the URL string using the required parameters
        if let appVanityDomain = authenticationViewModel.appVanityDomain {
            
            let urlString = "https://\(appVanityDomain)/signup"
            
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
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SignUpBrowserView>) {
    }
}
