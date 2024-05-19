import SwiftUI

struct SubHeaderView: View {
    let subHeader: String
    var body: some View {
        HStack {
            Text(subHeader)
                .foregroundColor(CustomColors.invoBlue)
                .font(.title2)
                .bold()
            Spacer()
        }
    }
}
