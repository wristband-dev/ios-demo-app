import SwiftUI
import SafariServices

struct BrowserView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<BrowserView>) -> SFSafariViewController {
        let urlString = "https://customer1-iosdemoapp-donato.us.wristband.dev/api/v1/oauth2/authorize?client_id=mlnp6h6nwrdd3ptqfvsi6pbieu&response_type=code&redirect_uri=demoapp%3A%2F%2Fcallback&state=jcm2ejayovsgbgbpkihblu47&nonce=gbgbpkihblu47jcm2ejayovs&scope=openid+offline_access&code_challenge=v8Bh0vp3j9dbGNeotHaJDUDHl0bS8aNk2OMeiSLBoc4&code_challenge_method=S256"
        
        guard let url = URL(string: urlString) else {
            
                
            return SFSafariViewController(url: URL(string: urlString)!)
        }
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<BrowserView>) {
    }
}
