import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var usersViewModel: UsersViewModel
    
    var body: some View {
        VStack {
            
            if let currentUser = usersViewModel.currentUser {
                HStack {
                    Text("User Info")
                        .bold()
                        .font(.title2)
                        .foregroundColor(CustomColors.invoBlue)
                    Spacer()
                }
                Divider()
                HStack{
                    Text("Email: ")
                    Text(currentUser.email)
                        .bold()
                    Spacer()
                }
            }
            VStack {
                HStack {
                    Spacer()
                    WristbandTouchPointView()
                }
                Button {
                    Task {
                        await authenticationViewModel.logout()
                    }
                } label: {
                    Text("Log Out")
                        .font(.headline)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(CustomColors.invoBlue)
                        .cornerRadius(8)
                }
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Settings")
        .padding()
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


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        // Instantiate view models
        let authenticationViewModel = AuthenticationViewModel()
        
        var usersViewModel = UsersViewModel()
        usersViewModel.currentUser = User(
            email: "test@example.com",
            givenName: "Test Given Name",
            id: "123",
            status: "Active",
            tenantId: "1"
        )
        
        return SettingsView()
            .environmentObject(authenticationViewModel)
            .environmentObject(usersViewModel)
    }
}
