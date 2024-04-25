import SwiftUI


struct AuthenticationView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            
            VStack {
                HStack {
                    Spacer()
                    WristbandTouchPointView()
                }
                Button {
                    authenticationViewModel.showLoginBrowser = true
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
                .sheet(isPresented: $authenticationViewModel.showLoginBrowser) {
                    if authenticationViewModel.tenantDomainName == nil {
                        AppLoginBrowserView()
                    } else {
                        TenantLoginBrowserView()
                    }
                }
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
        
        return NavigationStack {AuthenticationView()}
            .environmentObject(authenticationViewModel)
    }
}
