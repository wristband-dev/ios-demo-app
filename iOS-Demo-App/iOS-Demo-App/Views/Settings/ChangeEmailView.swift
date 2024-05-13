import SwiftUI

@MainActor
class ChangeEmailViewModel: ObservableObject {
    @Published var currentEmail: String = ""
    @Published var newEmail: String = ""
    
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
            TextField("New Email", text: $changeEmailViewModel.newEmail)
                .defaultTextFieldStyle()

            if changeEmailViewModel.emailChanged(email: currentUser.email), changeEmailViewModel.isValidEmail() {
                Button(action: {
                    Task {
                       
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
