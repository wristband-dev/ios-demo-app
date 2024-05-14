import Foundation

@MainActor
class UsersViewModel: ObservableObject {
    
    @Published var currentUser: User?
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
    
    func loadUsers(appId: String, appVanityDomain: String, token: String) async {
        do {
            self.currentUser = try await UsersService.shared.getUsers(appId: appId, appVanityDomain: appVanityDomain, token: token, start_index: 1, count: 50)
        } catch {
            print("Unable to load users: \(error)")
        }
    }
}
