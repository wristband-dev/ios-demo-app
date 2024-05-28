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
 
    func loadCurrentUser(appVanityDomain: String, token: String) async {
        do {
            self.currentUser = try await UsersService.shared.getCurrentUser(appVanityDomain: appVanityDomain, token:token)
        } catch {
            print("Unable to load current user: \(error)")
        }
    }
    
    func updateCurrentUser(updatedUser: UpdateUserBody) async {
        currentUser?.givenName = updatedUser.givenName
        currentUser?.familyName = updatedUser.familyName
        currentUser?.birthdate = updatedUser.birthdate
        currentUser?.phoneNumber = updatedUser.phoneNumber
    }
    
//    func loadUsers(appId: String, appVanityDomain: String, token: String) async {
//        do {
//            self.currentUser = try await UsersService.shared.getUsers(appId: appId, appVanityDomain: appVanityDomain, token: token, start_index: 1, count: 50)
//        } catch {
//            print("Unable to load users: \(error)")
//        }
//    }
    
    private func checkAdminStatus() {
        guard let roles = currentUser?.roles else {
            self.isAdmin = false
            return
        }
        self.isAdmin = roles.contains { $0.displayName == "owner" }
    }
}
