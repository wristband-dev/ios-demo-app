import SwiftUI


struct ContentView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Button("Open Browser") {
                authenticationViewModel.showBrowser = true
            }
            .sheet(isPresented: $authenticationViewModel.showBrowser) {
                BrowserView()
            }
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
