import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        Button {
            Task {
                await authenticationViewModel.logout()
            }
        } label: {
            Text("logout")
        }

    }
}

#Preview {
    SettingsView()
}
