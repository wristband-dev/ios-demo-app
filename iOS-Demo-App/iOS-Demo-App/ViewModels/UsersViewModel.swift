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
    
    func updateCurrentUser(updateUser: UpdateUserBody) async {
        currentUser?.givenName = updateUser.givenName
        currentUser?.familyName = updateUser.familyName
        currentUser?.birthdate = updateUser.birthdate
        currentUser?.phoneNumber = updateUser.phoneNumber
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
