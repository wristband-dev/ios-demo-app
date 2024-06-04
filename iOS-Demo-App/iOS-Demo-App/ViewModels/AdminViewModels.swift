import SwiftUI

@MainActor
class CompanyViewModel: ObservableObject {
    
    @Published var company: Company? = nil
    
    @Published var companyName = ""
    @Published var companyAddress = ""
    @Published var companyCity = ""
    @Published var companyZipCode = ""
    @Published var companyState = ""
    
    func getCompany(appVanityDomain: String, token: String, tenantId: String) async {
        do {
            // WRISTBAND_TOUCHPOINT
            let company = try await TenantService.shared.getTenant(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId).publicMetadata
            
            self.company = company
            self.companyName = company.companyName ?? ""
            self.companyAddress = company.companyAddress ?? ""
            self.companyCity = company.companyCity ?? ""
            self.companyZipCode = company.companyZipCode ?? ""
            self.companyState = company.companyState ?? ""
            
        } catch {
            print("Unable to get company: \(error)")
        }
    }
    
    func updateCompany(appVanityDomain: String, token: String, tenantId: String) async {
        do {
            let publicMetadataBody = TenantPublicMetadataBody(
                publicMetadata: Company(
                    companyName: self.companyName,
                    companyAddress: self.companyAddress, 
                    companyCity: self.companyCity,
                    companyZipCode: self.companyZipCode,
                    companyState: self.companyState
                )
            )
            
            // WRISTBAND_TOUCHPOINT
            try await TenantService.shared.patchTenant(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId, publicMetaDataBody: publicMetadataBody)
        } catch {
            print("Unable to update company: \(error)")
        }
    }
    
    func didCompanyChange() -> Bool {
        return companyName != company?.companyName ?? "" ||
        companyAddress != company?.companyAddress ?? "" ||
        companyCity != company?.companyCity ?? "" ||
        companyZipCode != company?.companyZipCode ?? "" ||
        companyState != company?.companyState ?? ""
    }
}

@MainActor
class InviteUserViewModel: ObservableObject {
    
    @Published var emailText: String = ""
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.emailText)
    }
    
    func inviteUser(appVanityDomain: String, token: String, tenantId: String, email: String, rolesToBeAssign: [String]) async {
        do {
            // WRISTBAND_TOUCHPOINT
            try await UsersService.shared.inviteNewUser(appVanityDomain: appVanityDomain, token: token, inviteUserBody: InviteUserBody(tenantId: tenantId, email: email, rolesToBeAssign: rolesToBeAssign))
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
            // WRISTBAND_TOUCHPOINT
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
            // WRISTBAND_TOUCHPOINT
            self.pendingUserInvites = try await UsersService.shared.getUserInvites(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId)
        } catch {
            print("Unable to get pending invites: \(error)")
        }
    }
    
    func cancelUserInvite(appVanityDomain: String, token: String, newUserInvitationRequestId: String) async {
        do {
            // WRISTBAND_TOUCHPOINT
            try await UsersService.shared.cancelUserInvite(appVanityDomain: appVanityDomain, token: token, cancelUserInviteBody: CancelUserInviteBody(newUserInvitationRequestId: newUserInvitationRequestId))
        } catch {
            print("Unable to get cancel invite: \(error)")
        }
    }
}
