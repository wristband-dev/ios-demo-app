import SwiftUI


struct LoginView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            
            VStack (spacing: 32) {
                Button {
                    if authenticationViewModel.tenantDomainName == nil {
                        authenticationViewModel.showAppLoginBrowser = true
                    } else {
                        authenticationViewModel.showTenantLoginBrowser = true
                    }
                } label: {
                    Text("Login")
                        .font(.title)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(CustomColors.invoBlue)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $authenticationViewModel.showAppLoginBrowser) {
                    AppLoginBrowserView()
                }
                .sheet(isPresented: $authenticationViewModel.showTenantLoginBrowser) {
                    TenantLoginBrowserView()
                }
                Button {
                    authenticationViewModel.showSignUpBrowser = true
                } label: {
                    Text("Sign Up")
                        .font(.title)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(CustomColors.invoBlue)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $authenticationViewModel.showSignUpBrowser) {
                    SignUpBrowserView()
                }
                Spacer()
                PoweredByWristbandView()
            }
            .padding([.trailing, .leading])
            
            if let errorMsg = authenticationViewModel.errorMsg {
                Text(errorMsg)
                    .bold()
                    .foregroundColor(.red)
            }
            Spacer()
            
            HStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
                Spacer()
            }
        }
        .padding()
        .navigationTitle("Invotastic")
    }
}


struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        let authenticationViewModel = AuthenticationViewModel()
        
        return NavigationStack {LoginView()}
            .environmentObject(authenticationViewModel)
    }
}
