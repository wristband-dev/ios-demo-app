import SwiftUI

struct PoweredByWristbandView: View {
   
    
    var body: some View {
        Text("Powered by Wristband")
            .font(.system(size: 14))
            .bold()
            .padding(6)
            .background(.blue)
            .cornerRadius(16)
            .foregroundColor(.white)
    }
}


struct WristbandTouchPointView_Previews: PreviewProvider {
    static var previews: some View {
        return PoweredByWristbandView()     
    }
}
