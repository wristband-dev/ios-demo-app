import SwiftUI

struct ContentView: View {
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            
            ForEach(usersViewModel.users) { user in
                Text(user.email)
            }
            
        }
        .onAppear {
//            Task {
//                if let token = await authenticationViewModel.getToken(), 
//                    let appVanityDomain = authenticationViewModel.appVanityDomain,
//                    let appId = authenticationViewModel.appId {
//                    
//                    print(Date())
//                    print(authenticationViewModel.tokenResponse?.tokenExpirationDate)
//                    await usersViewModel.loadUsers(appId: appId, appVanityDomain: appVanityDomain, token: token)
//                }
//            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink (value: "Settings") {
                    Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                        .foregroundColor(CustomColors.invoBlue)
                }
                
            }
        }
        .navigationDestination(for: String.self) { destination in
            switch destination {
                case "Settings":
                    SettingsView()
                default:
                    Text("Not Found")
            }
        }
    }
}

#Preview {
    ContentView()
}
