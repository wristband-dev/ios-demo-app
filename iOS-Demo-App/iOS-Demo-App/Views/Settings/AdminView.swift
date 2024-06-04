import SwiftUI

struct AdminView: View {
    @StateObject var companyViewModel = CompanyViewModel()
    @StateObject var rolesViewModel = RolesViewModel()
    @StateObject var pendingInvitesViewModel = PendingInvitesViewModel()
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var usersViewModel: UsersViewModel

    var body: some View {
        ScrollView {
            VStack {
                PoweredByWristbandView()
                VStack(spacing: 32) {
                    VStack {
                        SubHeaderView(subHeader: "Company Info")
                        CompanyInfoView()
                            .environmentObject(companyViewModel)
                    }
                    Divider()
                    VStack {
                        SubHeaderView(subHeader: "Invite Users")
                        RolesSelectView()
                            .environmentObject(rolesViewModel)
                        InviteTextFieldView(refreshPendingInvites: refreshPendingInvites)
                            .environmentObject(rolesViewModel)
                    }
                    if !pendingInvitesViewModel.pendingUserInvites.isEmpty {
                        Divider()
                        VStack {
                            SubHeaderView(subHeader: "Pending Invites")
                            PendingInvitesView(refreshPendingInvites: refreshPendingInvites)
                                .environmentObject(pendingInvitesViewModel)
                        }
                    }
                }
                .padding()
                .onAppear {
                    refreshPendingInvites()
                }
            }
        }
        .navigationTitle("Admin")
    }
    
    struct CompanyInfoView: View {
        @EnvironmentObject var companyViewModel: CompanyViewModel
        @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
        @EnvironmentObject var usersViewModel: UsersViewModel
        
        var body: some View {
            VStack {
                TextField("Name", text: $companyViewModel.companyName)
                    .defaultTextFieldStyle()
                Divider()
                TextField("Address", text: $companyViewModel.companyAddress)
                    .defaultTextFieldStyle()
                TextField("City", text: $companyViewModel.companyCity)
                    .defaultTextFieldStyle()
                HStack {
                    TextField("Zip Code", text: $companyViewModel.companyZipCode)
                        .defaultTextFieldStyle()
                    TextField("State", text: $companyViewModel.companyState)
                        .defaultTextFieldStyle()
                }
                if companyViewModel.didCompanyChange() {
                    Button(action: {
                        Task {
                            if let token = await authenticationViewModel.getToken(),
                               let appVanityDomain = authenticationViewModel.appVanityDomain,
                               let currentUser = usersViewModel.currentUser,
                               let tenantId = currentUser.tenantId {
                                await companyViewModel.updateCompany(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId)
                                await companyViewModel.getCompany(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId)
                            }
                        }
                    }, label: {
                        Text("Save")
                            .defaultButtonStyle()
                    })
                } else {
                    Text("Save")
                        .defaultButtonStyle().opacity(0.5)
                }
            }
            .onAppear {
                Task {
                    if let token = await authenticationViewModel.getToken(),
                       let appVanityDomain = authenticationViewModel.appVanityDomain,
                       let currentUser = usersViewModel.currentUser,
                       let tenantId = currentUser.tenantId {
                        await companyViewModel.getCompany(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId)
                    }
                }
            }
        }
    }

    struct RolesSelectView: View {
        @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
        @EnvironmentObject var rolesViewModel: RolesViewModel
        @EnvironmentObject var usersViewModel: UsersViewModel

        var body: some View {
            HStack {
                Menu {
                    ForEach(rolesViewModel.roles) { role in
                        Button(action: {
                            rolesViewModel.selectedRole = role
                        }) {
                            Text(role.displayName.capitalized)
                        }
                    }
                } label: {
                    Text(rolesViewModel.selectedRole?.displayName.capitalized ?? "Select Role")
                }
                .frame(width: 150, height: 40)
                .background(
                    rolesViewModel.selectedRole == nil ?
                    CustomColors.invoBlue.opacity(0.5) :
                        CustomColors.invoBlue
                
                )
                .foregroundColor(.white)
                .bold()
                .cornerRadius(8)
                Spacer()
            }
            .onAppear {
                Task {
                    if let token = await authenticationViewModel.getToken(),
                       let appVanityDomain = authenticationViewModel.appVanityDomain,
                       let currentUser = usersViewModel.currentUser,
                       let tenantId = currentUser.tenantId {
                        await rolesViewModel.getRoles(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId)
                    }
                }
            }
        }
    }

    struct InviteTextFieldView: View {
        @StateObject var inviteUserViewModel = InviteUserViewModel()
        @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
        @EnvironmentObject var rolesViewModel: RolesViewModel
        @EnvironmentObject var usersViewModel: UsersViewModel
        let refreshPendingInvites: () -> Void

        var body: some View {
            HStack {
                TextField("Email", text: $inviteUserViewModel.emailText)
                    .defaultTextFieldStyle()
                if inviteUserViewModel.isValidEmail(), let selectedRole = rolesViewModel.selectedRole {
                    Button(action: {
                        Task {
                            if let token = await authenticationViewModel.getToken(),
                               let appVanityDomain = authenticationViewModel.appVanityDomain,
                               let currentUser = usersViewModel.currentUser,
                               let tenantId = currentUser.tenantId  {
                                await inviteUserViewModel.inviteUser(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId, email: inviteUserViewModel.emailText.lowercased(), rolesToBeAssign: [selectedRole.id])
                                inviteUserViewModel.emailText = ""
                                refreshPendingInvites()
                            }
                        }
                    }, label: {
                        PlusButtonView()
                            .foregroundColor(CustomColors.invoBlue)
                    })
                } else {
                    PlusButtonView()
                        .foregroundColor(CustomColors.invoBlue.opacity(0.5))
                }
            }
        }

        struct PlusButtonView: View {
            var body: some View {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
            }
        }
    }

    struct PendingInvitesView: View {
        @EnvironmentObject var pendingInvitesViewModel: PendingInvitesViewModel
        @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
        let refreshPendingInvites: () -> Void

        var body: some View {
            VStack {
                ForEach(pendingInvitesViewModel.pendingUserInvites) { pendingUserInvite in
                    HStack {
                        Button(action: {
                            Task {
                                if let token = await authenticationViewModel.getToken(),
                                   let appVanityDomain = authenticationViewModel.appVanityDomain {
                                    await pendingInvitesViewModel.cancelUserInvite(appVanityDomain: appVanityDomain, token: token, newUserInvitationRequestId: pendingUserInvite.id)
                                    refreshPendingInvites()
                                }
                            }
                        }, label: {
                            Text("Cancel")
                                .frame(width: 100, height: 40)
                                .background(CustomColors.invoBlue)
                                .foregroundColor(.white)
                                .bold()
                                .cornerRadius(8)
                        })
                        Text(pendingUserInvite.email)
                            .bold()
                            .font(.headline)
                            .lineLimit(1)
                        Spacer()
                    }
                }
            }
        }
    }

    func refreshPendingInvites() {
        Task {
            if let token = await authenticationViewModel.getToken(),
               let appVanityDomain = authenticationViewModel.appVanityDomain,
               let currentUser = usersViewModel.currentUser,
               let tenantId = currentUser.tenantId {
                await pendingInvitesViewModel.getPendingInvites(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId)
            }
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        let companyViewModel = CompanyViewModel()
        companyViewModel.company = Company(companyName: "Test Name", companyAddress: "Address", companyCity: "city", companyZipCode: "Zip", companyState: "State")
        
        let rolesViewModel = RolesViewModel()
        rolesViewModel.roles = [
            Role(id: "1", name: "longname1", displayName: "display Name 1"),
            Role(id: "2", name: "longname2", displayName: "display Name 2")
        ]

        let pendingInvitesViewModel = PendingInvitesViewModel()
        pendingInvitesViewModel.pendingUserInvites = [
            PendingInvite(id: "1", externalIdpDisplayName: "test", rolesToAssign: [], metadata: Metadata(creationTime: "", version: "", lastModifiedTime: ""), expirationTime: "", tenantId: "", externalIdpRequestStatus: "", externalIdpName: "", applicationId: "", email: "test@gmail.com", externalIdpType: "", status: "")
        ]

        let authenticationViewModel = AuthenticationViewModel()
        let usersViewModel = UsersViewModel()

        return NavigationStack {
            AdminView()
                .environmentObject(companyViewModel)
                .environmentObject(rolesViewModel)
                .environmentObject(pendingInvitesViewModel)
                .environmentObject(authenticationViewModel)
                .environmentObject(usersViewModel)
        }
    }
}
