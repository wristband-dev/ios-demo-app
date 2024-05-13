//import SwiftUI
//
//
//
//@MainActor
//class ChangeEmailViewModel: ObservableObject {
//    @Published var currentEmail: String = ""
//    @Published var newEmail: String = ""
//}
////
////@MainActor
////class ChangePasswordViewModel: ObservableObject {
////    @Published var currentPassword: String = ""
////    @Published var newPassword: String = ""
////    @Published var newPasswordConfirm: String = ""
////}
//
//struct SettingsView: View {
//    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
//    @EnvironmentObject var usersViewModel: UsersViewModel
//    
//    @StateObject var settingsViewModel = UpdateUserViewModel()
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Text("User Info")
//                    .bold()
//                    .font(.title2)
//                    .foregroundColor(CustomColors.invoBlue)
//                Spacer()
//            }
//            Divider()
//            HStack {
//                TextField("First Name", text: $settingsViewModel.givenName)
//                    .defaultTextFieldStyle()
//                TextField("Last Name", text: $settingsViewModel.familyName)
//                    .defaultTextFieldStyle()
//            }
//            TextField("Email", text: $settingsViewModel.email)
//                .defaultTextFieldStyle()
//            
//           
//            
//            if let user = usersViewModel.currentUser {
//                if settingsViewModel.givenName != user.givenName ?? "" ||
//                   settingsViewModel.familyName != user.familyName ?? "" ||
//                   settingsViewModel.email != user.email {
//                    Button(action: {
//                        Task {
//                            if let token = await authenticationViewModel.getToken(), let appVanityDomain = authenticationViewModel.appVanityDomain {
//                                await usersViewModel.updateCurrentUser(appVanityDomain: appVanityDomain, token: token)
//                            }
//                        }
//                    }, label: {
//                        Text("Save")
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(.blue)
//                            .cornerRadius(8)
//                            .foregroundColor(.white)
//                            .bold()
//                            .padding(.top)
//                    })
//                }
//            }
//            Spacer()
//            LogoutButtonView()
//            
//        }
//        .navigationTitle("Settings")
//        .navigationBarTitleDisplayMode(.inline)
//        .padding()
//        .onAppear {
//            Task {
//                if let token = await authenticationViewModel.getToken(), let appVanityDomain = authenticationViewModel.appVanityDomain {
//                    await usersViewModel.loadCurrentUser(appVanityDomain: appVanityDomain, token: token)
//                    if let currentUser = usersViewModel.currentUser, let givenName = currentUser.givenName, let familyName = currentUser.familyName {
//                        settingsViewModel.email = currentUser.email
//                        settingsViewModel.givenName = givenName
//                        settingsViewModel.familyName = familyName
//                    }
//                }
//            }
//        }
//        .sheet(isPresented: $authenticationViewModel.showLogOutBrowser) {
//            LogoutBrowserView()
//        }
//    }
//    
//    struct LogoutButtonView: View {
//        @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
//        
//        var body: some View {
//            VStack {
//                Button {
//                    Task {
//                        await authenticationViewModel.logout()
//                    }
//                } label: {
//                    Text("Log Out")
//                        .defaultButtonStyle()
//                }
//            }
//        }
//    }
//}
//
//
//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Instantiate view models
//        let authenticationViewModel = AuthenticationViewModel()
//        
//        let usersViewModel = UsersViewModel()
//        usersViewModel.currentUser = User(id: "1", appId: "1", email: "fddiferd@gmail.com", emailVerified: true, givenName: "Donato", familyName: "DiFerdinando", middleName: "", nickname: nil, pictureUrl: nil, gender: nil, birthdate: nil, locale: "US", timezone: nil, identityProviderName: nil, tenantId: nil, updatedAt: nil)
//        
//        return SettingsView()
//            .environmentObject(authenticationViewModel)
//            .environmentObject(usersViewModel)
//    }
//}
//
//
