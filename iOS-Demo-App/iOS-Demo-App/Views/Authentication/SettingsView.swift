import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var usersViewModel: UsersViewModel
    
    var body: some View {
        VStack {
            
            Button {
                Task {
                    await authenticationViewModel.logout()
                }
            } label: {
                Text("logout")
            }
            
            if let currentUser = usersViewModel.currentUser {
                Text(currentUser.email)
            }
            
        }
        .onAppear {
            Task {
                if let token = await authenticationViewModel.getToken(), let appVanityDomain = authenticationViewModel.appVanityDomain {
                    await usersViewModel.loadCurrentUser(appVanityDomain: appVanityDomain, token: token)
                }
            }
        }
        .sheet(isPresented: $authenticationViewModel.showLogOutBrowser) {
            LogoutBrowserView()
        }
    }
}

#Preview {
    SettingsView()
}
