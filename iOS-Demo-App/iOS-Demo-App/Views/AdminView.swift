import SwiftUI


struct AdminView: View {
    @StateObject var rolesViewModel = RolesViewModel()
    @StateObject var pendingInvitesViewModel = PendingInvitesViewModel()
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        VStack(spacing: 32) {
            VStack {
                SubHeaderView(subHeader: "Invite Users")
                RolesSelectView()
                    .environmentObject(rolesViewModel)
                InviteTextFieldView(refreshPendingInvites: refreshPendingInvites)
                    .environmentObject(rolesViewModel)
            }
            Divider()
            VStack {
                SubHeaderView(subHeader: "Pending Invites")
                PendingInvitesView(refreshPendingInvites: refreshPendingInvites)
                    .environmentObject(pendingInvitesViewModel)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Admin")
    }

    struct RolesSelectView: View {
        @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
        @EnvironmentObject var rolesViewModel: RolesViewModel

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
                .background(CustomColors.invoBlue)
                .foregroundColor(.white)
                .bold()
                .cornerRadius(8)
                Spacer()
            }
            .onAppear {
                Task {
                    if let token = await authenticationViewModel.getToken(),
                       let appVanityDomain = authenticationViewModel.appVanityDomain,
                       let tenantId = authenticationViewModel.tenantId {
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
                               let appId = authenticationViewModel.appId,
                               let tenantId = authenticationViewModel.tenantId {
                                await inviteUserViewModel.inviteUser(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId, appId: appId, email: inviteUserViewModel.emailText.lowercased(), rolesToBeAssign: [selectedRole.id])
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
                            Image(systemName: "x.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 35)
                                .foregroundColor(.red)
                        })
                        Text(pendingUserInvite.email)
                            .bold()
                            .font(.title3)
                            .lineLimit(1)
                        Spacer()
                    }
                }
            }
            .onAppear {
                refreshPendingInvites()
            }
        }
    }

    func refreshPendingInvites() {
        Task {
            if let token = await authenticationViewModel.getToken(),
               let appVanityDomain = authenticationViewModel.appVanityDomain,
               let tenantId = authenticationViewModel.tenantId {
                await pendingInvitesViewModel.getPendingInvites(appVanityDomain: appVanityDomain, token: token, tenantId: tenantId)
            }
        }
    }
}

struct AdminView_Preview: PreviewProvider {
    static var previews: some View {
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

        return NavigationStack {
            AdminView()
                .environmentObject(rolesViewModel)
                .environmentObject(pendingInvitesViewModel)
                .environmentObject(authenticationViewModel)
        }
    }
}
