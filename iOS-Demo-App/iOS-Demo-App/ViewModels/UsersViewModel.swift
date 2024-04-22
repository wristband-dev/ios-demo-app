import Foundation

@MainActor
class UsersViewModel: ObservableObject {
    
    @Published var currentUser: User?

 
    func loadCurrentUser(appVanityDomain: String, token: String) async {
        do {
            print("Starting load current user")
            self.currentUser = try await UsersService.shared.getCurrentUser(appVanityDomain: appVanityDomain, token:token)
        } catch {
            print("Unable to load current user: \(error)")
        }
    }
}
