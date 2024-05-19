import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    let currentUser: User
    
    var body: some View {        
        ScrollView {
            VStack (spacing: 32) {
                VStack {
                    SubHeaderView(subHeader: "User Info")
                    UpdateUserInfoView(currentUser: currentUser)
                }
                Divider()
                VStack {
                    SubHeaderView(subHeader: "Update Email")
                    ChangeEmailView(currentUser: currentUser)
                }
                Divider()
                VStack {
                    SubHeaderView(subHeader: "Change Password")
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
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Settings")
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
}

struct NewSettings_Previews: PreviewProvider {
    static var previews: some View {
        let authenticationViewModel = AuthenticationViewModel()
        
        let currentUser = User(id: "1", appId: "1", email: "fddiferd@gmail.com", emailVerified: true, givenName: "Donato", familyName: "DiFerdinando", middleName: "", nickname: nil, pictureUrl: nil, gender: nil, birthdate: nil, locale: "US", timezone: nil, identityProviderName: nil, tenantId: nil, updatedAt: nil)
        
        return NavigationStack {
            SettingsView(currentUser: currentUser)
                .environmentObject(authenticationViewModel)
        }
    }
}
