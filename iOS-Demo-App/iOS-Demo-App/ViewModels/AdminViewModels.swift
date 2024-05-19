import SwiftUI

@MainActor
class InviteUserViewModel: ObservableObject {
    
    @Published var emailText: String = ""
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.emailText)
    }
    
    func inviteUser(appVanityDomain: String, token: String, tenantId: String, appId: String, email: String, rolesToBeAssign: [String]) async {
        do {
            try await UsersService.shared.inviteNewUser(appVanityDomain: appVanityDomain, token: token, inviteUserBody: InviteUserBody(tenantId: tenantId, appId: appId, email: email, rolesToBeAssign: rolesToBeAssign))
        } catch {
            print("Unable to invite user: \(error)")
        }
    }
}

@MainActor
class RolesViewModel: ObservableObject {
    
    @Published var roles: [Role] = []
    @Published var selectedRole: Role?
    
    func getRoles(appVanityDomain: String, token: String, tenantId: String) async {
        do {
            self.roles = try await UsersService.shared.getRoles(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId).items
        } catch {
            print("Unable to get roles: \(error)")
        }
    }
    
}

@MainActor
class PendingInvitesViewModel: ObservableObject {
    
    @Published var pendingUserInvites: [PendingInvite] = []
    
    func getPendingInvites(appVanityDomain: String, token: String, tenantId: String) async {
        do {
            self.pendingUserInvites = try await UsersService.shared.getUserInvites(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId)
        } catch {
            print("Unable to get pending invites: \(error)")
        }
    }
    
    func cancelUserInvite(appVanityDomain: String, token: String, newUserInvitationRequestId: String) async {
        do {
            try await UsersService.shared.cancelUserInvite(appVanityDomain: appVanityDomain, token: token, cancelUserInviteBody: CancelUserInviteBody(newUserInvitationRequestId: newUserInvitationRequestId))
        } catch {
            print("Unable to get cancel invite: \(error)")
        }
    }
}
