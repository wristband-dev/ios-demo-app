import SwiftUI


struct ContentView: View {
    @EnvironmentObject var browserViewModel: BrowserViewModel

    var body: some View {
        VStack {
            Text("Hello, world!")
            Button("Open Browser") {
                browserViewModel.showBrowser = true
            }
            .sheet(isPresented: $browserViewModel.showBrowser) {
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
