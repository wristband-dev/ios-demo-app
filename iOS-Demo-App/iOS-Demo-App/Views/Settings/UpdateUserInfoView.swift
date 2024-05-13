import SwiftUI

struct UpdateUser: Encodable {
    var id: String
    var givenName: String?
    var familyName: String?
    var birthdate: String?
    var phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case familyName, id, givenName, birthdate, phoneNumber
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(familyName, forKey: .familyName)
        try container.encode(id, forKey: .id)
        try container.encode(givenName, forKey: .givenName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(birthdate, forKey: .birthdate)
        if birthdate == nil {
            try container.encodeNil(forKey: .birthdate)
        }
    }
}

@MainActor
class UpdateUserViewModel: ObservableObject {
    
    @Published var givenName: String = ""
    @Published var familyName: String = ""
    
    @Published var phoneNumber: String = ""
    
    @Published var showBirthdate: Bool = false
    @Published var birthdate: Date = Date()
    
    func setUser(currentUser: User) {
        if let givenName = currentUser.givenName {
            self.givenName = givenName
        }
        if let familyName = currentUser.familyName {
            self.familyName = familyName
        }
        if let birthdateString = currentUser.birthdate, let birthdate = stringToDate(birthdateString) {
            self.birthdate = birthdate
        }
        if let phoneNumber = currentUser.phoneNumber {
            self.phoneNumber = phoneNumber
        }
    }
    
    func getNewUser(currentUser: User) -> UpdateUser {
        var newUser = UpdateUser(
            id: currentUser.id,
            givenName: self.givenName,
            familyName: self.familyName,
            phoneNumber:self.phoneNumber
        )
        
        if birthdateChanged(currentUser.birthdate) {
            if self.showBirthdate {
                newUser.birthdate = dateToString(self.birthdate)
            } else {
                newUser.birthdate = nil
            }
        }
        return newUser
    }
    
    func userChanged(currentUser: User) -> Bool {
        if givenNameChanged(currentUser.givenName) ||
            familyNameChanged(currentUser.familyName) ||
            phoneNumberChanged(currentUser.phoneNumber) ||
            birthdateChanged(currentUser.birthdate)
        {
            return true
        } else {
            return false
        }
    }
    
    func givenNameChanged(_ givenName: String?) -> Bool {
        return self.givenName != givenName ?? ""
    }
    
    func familyNameChanged(_ familyName: String?) -> Bool {
        return self.familyName != familyName ?? ""
    }
    
    func phoneNumberChanged(_ phoneNumber: String?) -> Bool {
        return self.phoneNumber != phoneNumber ?? ""
    }
    
    func birthdateChanged(_ birthdate: String?) -> Bool {
        // birthdate not previously set
        if birthdate == nil {
            if self.showBirthdate {
                // now showing birthdate
                return true
            } else {
                // still showing no birthdate
                return false
            }
        } else {
            if self.showBirthdate {
                // birthdate still shown
                if birthdate == dateToString(self.birthdate) {
                    // birthdate unchanged
                    return false
                } else {
                    // different birthdate
                    return true
                }
            } else {
                // now not showing birthdate
                return true
            }
        }
    }
}

struct UpdateUserInfoView: View {
    @StateObject var updateUserViewModel = UpdateUserViewModel()
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var currentUser: User
    
    var body: some View {
        NavigationStack {
            VStack {
                BirthdateView(currentUser: currentUser)
                TextField("Phone Number", text: $updateUserViewModel.phoneNumber)
                    .defaultTextFieldStyle()
                    .keyboardType(.numberPad)
                HStack {
                    TextField("First Name", text: $updateUserViewModel.givenName)
                        .defaultTextFieldStyle()
                    TextField("Last Name", text: $updateUserViewModel.familyName)
                        .defaultTextFieldStyle()
                }
                if usersViewModel.showErrorMessage {
                    Text(usersViewModel.errorMessage)
                        .foregroundColor(.red)
                        .italic()
                        .bold()
                }
                if updateUserViewModel.userChanged(currentUser: currentUser) {
                    Button(action: {
                        Task {
                            if let token = await authenticationViewModel.getToken(), let appVanityDomain = authenticationViewModel.appVanityDomain {
                                let newUser = updateUserViewModel.getNewUser(currentUser: currentUser)

                                await usersViewModel.updateCurrentUser(appVanityDomain: appVanityDomain, token: token, newUser: newUser)
                            }
                        }
                    }, label: {
                        Text("Save")
                            .defaultButtonStyle()
                    })
                } else {
                    Text("Save")
                        .defaultButtonStyle(opacity: 0.5)
                }
            }
            .onAppear {
                updateUserViewModel.setUser(currentUser: currentUser)
            }
        }
        .environmentObject(updateUserViewModel)
    }
    
    struct BirthdateView: View {
        @EnvironmentObject var updateUserViewModel: UpdateUserViewModel
        
        let currentUser: User
        var body: some View {
            HStack {
                if !updateUserViewModel.showBirthdate {
                    Button(action: {
                        updateUserViewModel.showBirthdate = true
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .foregroundColor(CustomColors.invoBlue)
                    })
                } else {
                    Button(action: {
                        updateUserViewModel.showBirthdate = false
                    }, label: {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .foregroundColor(.red)
                    })
                }
                Text("Birthdate")
                    .font(.title3)
                    .bold()
                
                if updateUserViewModel.showBirthdate {
                    DatePicker(
                        "",
                        selection: $updateUserViewModel.birthdate,
                        in: ...Date.now,
                        displayedComponents: .date
                    )
                    .bold()
                } else {
                    Spacer()
                }
            }
            .frame(height: 55)
        }
    }
}

struct UpdateUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let currentUser = User(id: "1'", email: "fddiferd@gmail.com", emailVerified: true, givenName: "Donato", locale: "US")

        return UpdateUserInfoView(currentUser: currentUser)
    }
}


