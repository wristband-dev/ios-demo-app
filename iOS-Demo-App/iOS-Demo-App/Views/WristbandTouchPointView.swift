import SwiftUI

struct WristbandTouchPointView: View {
   
    
    var body: some View {
        Text("Wristband Touchpoint")
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
        return WristbandTouchPointView()     
    }
}
