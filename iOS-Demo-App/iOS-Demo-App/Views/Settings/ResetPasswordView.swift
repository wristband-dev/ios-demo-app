import SwiftUI

@MainActor
class ResetPasswordViewModel: ObservableObject {
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var newPasswordConfirm: String = ""
    
    
}

struct ResetPasswordView: View {
    @StateObject var changePasswordViewModel = ResetPasswordViewModel()
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            TextField("Current Password", text: $changePasswordViewModel.currentPassword)
                .defaultTextFieldStyle()
            TextField("New Password", text: $changePasswordViewModel.newPassword)
                .defaultTextFieldStyle()
            TextField("Confirm New Password", text: $changePasswordViewModel.newPasswordConfirm)
                .defaultTextFieldStyle()
            
            if changePasswordViewModel.currentPassword != "",
               changePasswordViewModel.newPassword != "",
               changePasswordViewModel.newPasswordConfirm != "",
               changePasswordViewModel.newPassword == changePasswordViewModel.newPasswordConfirm {
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
    }
}

#Preview {
    ResetPasswordView()
}
