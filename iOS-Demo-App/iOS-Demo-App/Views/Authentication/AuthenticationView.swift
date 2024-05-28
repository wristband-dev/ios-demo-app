import SwiftUI


struct AuthenticationView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            if authenticationViewModel.isLoading {
                ProgressView()
            } else if authenticationViewModel.tokenResponse == nil {
                LoginView()
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
