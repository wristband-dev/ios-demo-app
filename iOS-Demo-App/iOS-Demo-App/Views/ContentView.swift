import SwiftUI

struct ContentView: View {
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
        
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                        .foregroundColor(CustomColors.invoBlue)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
