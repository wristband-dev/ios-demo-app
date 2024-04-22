import SwiftUI


struct AuthenticationView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel


    var body: some View {
        VStack {
            Button {
                authenticationViewModel.showLoginBrowser = true
            } label: {
                Text("Login")
                    .font(.title)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $authenticationViewModel.showLoginBrowser) {
                if authenticationViewModel.tenantDomainName == nil {
                    AppLoginBrowserView()
                } else {
                    TenantLoginBrowserView()
                }
            }
            if let errorMsg = authenticationViewModel.errorMsg {
                Text(errorMsg)
                    .bold()
                    .foregroundColor(.red)
            }
            Spacer()
        }
        .navigationTitle("Wristband")
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView()
        }
    }
}
