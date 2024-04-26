import SwiftUI


struct LandingView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            if authenticationViewModel.isLoading {
                ProgressView()
            } else if authenticationViewModel.tokenResponse == nil {
                AuthenticationView()
            } else {
                ContentView()
            }
        }
        .onAppear {
            Task {
                await authenticationViewModel.getStoredToken()
            }
        }
    }
}


struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
