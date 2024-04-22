import SwiftUI


struct AuthenticationView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Text(authenticationViewModel.isUserAuthenticated ? "True" : "False")
            Button("Open Browser") {
                authenticationViewModel.showBrowser = true
            }
            .sheet(isPresented: $authenticationViewModel.showBrowser) {
                if authenticationViewModel.tenantDomainName == nil {
                    AppLoginBrowserView()
                } else {
                    TenantLoginBrowserView()
                }
            }
            .onChange(of: authenticationViewModel.tokenResponse, initial: true) { oldToken, newToken in
                
            }
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
