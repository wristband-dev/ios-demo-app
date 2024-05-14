import SwiftUI


struct ChangePasswordBody: Encodable {
    var userId: String
    var currentPassword: String
    var newPassword: String
}

@MainActor
class ChangePasswordViewModel: ObservableObject {
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var newPasswordConfirm: String = ""
    
    @Published var showErrorMessage: Bool = false
    
    func changePassword(appVanityDomain: String, token: String, changePasswordBody: ChangePasswordBody) async {
        do {
            try await UsersService.shared.changePassword(appVanityDomain: appVanityDomain, token: token, changePasswordBody: changePasswordBody)
            self.showErrorMessage = false
        } catch {
            self.showErrorMessage = true
            print("Unable to change password: \(error)")
        }
    }
    
    func newPasswordValid() -> Bool {
        return self.currentPassword != "" &&
            self.newPassword != "" &&
            self.newPasswordConfirm != "" &&
            self.newPassword == self.newPasswordConfirm
    }
    
    func getChangePasswordBody(userId: String) -> ChangePasswordBody {
        return ChangePasswordBody(userId: userId, currentPassword: self.currentPassword, newPassword: self.newPassword)
    }
    
    func confirmPasswordIndicator() -> Bool? {
        if self.newPassword == "" && self.newPasswordConfirm == "" {
            return nil
        } else if self.newPassword != self.newPasswordConfirm {
            return false
        } else {
            return true
        }
    }
    
    func resetFields() {
        self.currentPassword = ""
        self.newPassword = ""
        self.newPasswordConfirm = ""
    }
}

struct ChangePasswordView: View {
    @StateObject var changePasswordViewModel = ChangePasswordViewModel()
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var usersViewModel: UsersViewModel
    
    let currentUser: User
    
    var body: some View {
        VStack {
            SecureField("Current Password", text: $changePasswordViewModel.currentPassword)
                .defaultTextFieldStyle()
            SecureField("New Password", text: $changePasswordViewModel.newPassword)
                .defaultTextFieldStyle()
            HStack {
                SecureField("Confirm New Password", text: $changePasswordViewModel.newPasswordConfirm)
                    .defaultTextFieldStyle()
                if let indicatorStatus =  changePasswordViewModel.confirmPasswordIndicator() {
                    Image(systemName: (indicatorStatus ? "checkmark" : "x") + ".circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(indicatorStatus ? .green : .red)
                }
            }
            if changePasswordViewModel.showErrorMessage {
                Text("Unable to update current user")
                    .foregroundColor(.red)
                    .italic()
                    .bold()
            }
            if changePasswordViewModel.newPasswordValid() {
                Button(action: {
                    Task {
                        if let token = await authenticationViewModel.getToken(), let appVanityDomain = authenticationViewModel.appVanityDomain {
                            let changePasswordBody = changePasswordViewModel.getChangePasswordBody(userId: currentUser.id)
                            await changePasswordViewModel.changePassword(appVanityDomain: appVanityDomain, token: token, changePasswordBody: changePasswordBody)
                            changePasswordViewModel.resetFields()
                        }
                    }
                }, label: {
                    Text("Change Password")
                        .defaultButtonStyle()
                })
            } else {
                Text("Change Password")
                    .defaultButtonStyle(opacity: 0.5)
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let currentUser = User(id: "1'", email: "fddiferd@gmail.com", emailVerified: true, givenName: "Donato", locale: "US")

        return ChangePasswordView(currentUser: currentUser)
    }
}


