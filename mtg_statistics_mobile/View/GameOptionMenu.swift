import SwiftUI

/// A view that displays game options (reset, roll dice, and submit) in a vertical layout.
struct GameOptionsMenu: View {
    var resetAction: () -> Void
    var rollDiceAction: () -> Void
    var submitAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Button(action: resetAction) {
                Image(systemName: "arrow.clockwise.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
            }
            Button(action: rollDiceAction) {
                Image(systemName: "die.face.6")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
            }
            Button(action: submitAction) {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        .shadow(radius: 10)
    }
}

struct GameOptionsMenu_Previews: PreviewProvider {
    static var previews: some View {
        GameOptionsMenu(
            resetAction: { print("Reset pressed") },
            rollDiceAction: { print("Roll dice pressed") },
            submitAction: { print("Submit pressed") }
        )
        .previewLayout(.sizeThatFits)
    }
}
