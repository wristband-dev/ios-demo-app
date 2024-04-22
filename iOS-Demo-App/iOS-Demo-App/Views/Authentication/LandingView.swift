import SwiftUI


struct LandingView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        if authenticationViewModel.showAuthenticationView {
            AuthenticationView()
        } else {
            ContentView()
        }
    }
}


struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
