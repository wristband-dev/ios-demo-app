import SwiftUI

struct ChangeEmailBody: Encodable {
    var userId: String
    var newEmail: String
}

@MainActor
class ChangeEmailViewModel: ObservableObject {
    @Published var currentEmail: String = ""
    @Published var newEmail: String = ""
    
    @Published var showErrorMessage: Bool = false
    @Published var showSuccessMessage: Bool = false
    
    func changeEmail(appVanityDomain: String, token: String, changeEmailBody: ChangeEmailBody) async {
        do {
            try await UsersService.shared.changeEmail(appVanityDomain: appVanityDomain, token: token, changeEmailBody: changeEmailBody)
            self.newEmail = ""
            self.showSuccessMessage = true
            self.showErrorMessage = false
        } catch {
            self.showErrorMessage = true
            print("Unable to change password: \(error)")
        }
    }
    
    func getChangeEmailBody(userId: String) -> ChangeEmailBody {
        return ChangeEmailBody(userId: userId, newEmail: self.newEmail)
    }
    
    func emailChanged(email: String) -> Bool {
        return email != self.newEmail
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.newEmail)
    }
}

struct ChangeEmailView: View {
    @StateObject var changeEmailViewModel = ChangeEmailViewModel()
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    let currentUser: User
    
    var body: some View {
        VStack {            
            TextField("Current Email", text: $changeEmailViewModel.currentEmail)
                .defaultTextFieldStyle()
            HStack {
                TextField("New Email", text: $changeEmailViewModel.newEmail)
                    .defaultTextFieldStyle()
                if changeEmailViewModel.newEmail != "" {
                    let validEmail = changeEmailViewModel.isValidEmail()
                    Image(systemName: (validEmail ? "checkmark" : "x") + ".circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(validEmail ? .green : .red)
                }
            }
            if changeEmailViewModel.showErrorMessage {
                Text("Unable to change email")
                    .foregroundColor(.red)
                    .italic()
                    .bold()
            }
            if changeEmailViewModel.showSuccessMessage {
                Text("Email reset sent to new email")
                    .foregroundColor(.green)
                    .italic()
                    .bold()
            }
            if changeEmailViewModel.emailChanged(email: currentUser.email), changeEmailViewModel.isValidEmail() {
                Button(action: {
                    Task {
                        if let token = await authenticationViewModel.getToken(), let appVanityDomain = authenticationViewModel.appVanityDomain {
                            let changeEmailBody = changeEmailViewModel.getChangeEmailBody(userId: currentUser.id)
                            await changeEmailViewModel.changeEmail(appVanityDomain:appVanityDomain, token:token, changeEmailBody: changeEmailBody)
                            
                        }
                    }
                }, label: {
                    Text("Change Email")
                        .defaultButtonStyle()
                })
            } else {
                Text("Change Email")
                    .defaultButtonStyle(opacity: 0.5)
            }
        }
        .onAppear {
            changeEmailViewModel.currentEmail = currentUser.email
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let currentUser = User(id: "1'", email: "fddiferd@gmail.com", emailVerified: true, locale: "US")

        return ChangeEmailView(currentUser: currentUser)
    }
}
