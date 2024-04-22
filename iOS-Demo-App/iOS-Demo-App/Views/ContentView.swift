import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        Button(action: {
            print("token exp - \(authenticationViewModel.tokenResponse?.tokenExpirationDate)")
            print("current time - \(Date())")
        }, label: {
            Text("Button")
        })
    }
}

#Preview {
    ContentView()
}
