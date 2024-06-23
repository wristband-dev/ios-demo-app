import Foundation

@MainActor
class UsersViewModel: ObservableObject {
    
    //current user
    @Published var currentUser: User? {
        didSet {
            checkAdminStatus()
        }
    }
    @Published var isAdmin: Bool = false
    
    @Published var users: [User] = []
 
    func loadCurrentUser(appVanityDomain: String, token: String) async -> String? {
        do {
            // WRISTBAND_TOUCHPOINT
            let user = try await UsersService.shared.getCurrentUser(appVanityDomain: appVanityDomain, token:token)
            self.currentUser = user
            return user.tenantId
        } catch {
            print("Unable to load current user: \(error)")
        }
        return nil
    }
    
    func updateCurrentUser(updatedUser: UpdateUserBody) async {
        currentUser?.givenName = updatedUser.givenName
        currentUser?.familyName = updatedUser.familyName
        currentUser?.birthdate = updatedUser.birthdate
        currentUser?.phoneNumber = updatedUser.phoneNumber
    }
    
    private func checkAdminStatus() {
        guard let roles = currentUser?.roles else {
            self.isAdmin = false
            return
        }
        self.isAdmin = roles.contains { $0.displayName.lowercased() == "owner" }
    }
}
