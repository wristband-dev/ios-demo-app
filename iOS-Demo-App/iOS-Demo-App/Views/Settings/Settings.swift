import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    
    @State var loaded: Bool = false
    
    var body: some View {        
        ScrollView {
            if self.loaded {
                VStack (spacing: 32) {
                    if let currentUser = usersViewModel.currentUser {
                        VStack {
                            subHeaderView(subHeader: "User Info")
                            UpdateUserInfoView(currentUser: currentUser)
                        }
                        Divider()
                        VStack {
                            subHeaderView(subHeader: "Update Email")
                            ChangeEmailView(currentUser: currentUser)
                        }
                        Divider()
                        VStack {
                            subHeaderView(subHeader: "Change Password")
                            ChangePasswordView(currentUser: currentUser)
                        }
                        Divider()
                        Button {
                            Task {
                                await authenticationViewModel.logout()
                                
                            }
                        } label: {
                            Text("Logout")
                                .defaultButtonStyle()
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                if let token = await authenticationViewModel.getToken(), let appVanityDomain = authenticationViewModel.appVanityDomain {
                    await usersViewModel.loadCurrentUser(appVanityDomain: appVanityDomain, token: token)

                    self.loaded = true
                }
            }
        }
        .sheet(isPresented: $authenticationViewModel.showLogOutBrowser) {
            LogoutBrowserView()
        }
    }
    
    struct LineItemView: View {
        let label: String
        let item: String
        
        var body: some View {
            HStack {
                Text("\(label)").bold()
                Spacer()
                Text(item)
            }
        }
    }
    
    struct subHeaderView: View {
        let subHeader: String
        var body: some View {
            HStack {
                Text(subHeader)
                    .foregroundColor(CustomColors.invoBlue)
                    .font(.title2)
                    .bold()
                Spacer()
            }
        }
    }
}

struct NewSettings_Previews: PreviewProvider {
    static var previews: some View {
        // Instantiate view models
        let authenticationViewModel = AuthenticationViewModel()
        
        let usersViewModel = UsersViewModel()
        usersViewModel.currentUser = User(id: "1", appId: "1", email: "fddiferd@gmail.com", emailVerified: true, givenName: "Donato", familyName: "DiFerdinando", middleName: "", nickname: nil, pictureUrl: nil, gender: nil, birthdate: nil, locale: "US", timezone: nil, identityProviderName: nil, tenantId: nil, updatedAt: nil)
        
        return NavigationStack {
            SettingsView(loaded: true)
                .environmentObject(authenticationViewModel)
                .environmentObject(usersViewModel)
        }
    }
}

