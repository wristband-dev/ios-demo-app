import Foundation
import SwiftUI

extension View {
    func defaultTextFieldStyle() -> some View {
        self.modifier(DefaultTextFieldModifier())
    }
    
    func defaultButtonStyle(opacity: Double = 1.0) -> some View {
        self.modifier(DefaultButtonModifier(opacity: opacity))
    }
}

struct DefaultTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
    }
}

struct DefaultButtonModifier: ViewModifier {
    let opacity: Double 
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .bold()
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(CustomColors.invoBlue.opacity(opacity))
            .cornerRadius(8)
    }
}
