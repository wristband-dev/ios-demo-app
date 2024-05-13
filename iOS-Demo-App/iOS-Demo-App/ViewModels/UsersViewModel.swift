import Foundation

@MainActor
class UsersViewModel: ObservableObject {
    
    @Published var currentUser: User?
    @Published var users: [User] = []
    
    @Published var showErrorMessage: Bool = false
    @Published var errorMessage: String = ""

 
    func loadCurrentUser(appVanityDomain: String, token: String) async {
        do {
            self.currentUser = try await UsersService.shared.getCurrentUser(appVanityDomain: appVanityDomain, token:token)
        } catch {
            print("Unable to load current user: \(error)")
        }
    }
    
    func updateCurrentUser(appVanityDomain: String, token: String, newUser: UpdateUser) async {
        do {
            try await UsersService.shared.updateCurrentUser(appVanityDomain: appVanityDomain, token:token, user: newUser)
            await mapToCurrentUser(updateUser: newUser)
            self.showErrorMessage = false
        } catch {
            self.showErrorMessage = true
            self.errorMessage = "Unable to update current user"
            print("Unable to update current user: \(error)")
        }
    }

    func mapToCurrentUser(updateUser: UpdateUser) async {
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
