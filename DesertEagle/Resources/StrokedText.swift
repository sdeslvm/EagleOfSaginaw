import SwiftUI

struct StrokedText: View {
    var text: String
    var font: Font
    var strokeColor: Color
    var textColor: Color
    var strokeWidth: CGFloat
    
    init(text: String,  size: CGFloat = 44, strokeColor: Color = Color(red: 0.937, green: 0.459, blue: 0.102), textColor: Color = .white, strokeWidth: CGFloat = 2) {
        self.text = text
        self.font = .Cubano(size: size)
        self.strokeColor = strokeColor
        self.textColor = textColor
        self.strokeWidth = strokeWidth
    }

    var body: some View {
        ZStack {
            // Обводка
            Text(text)
                .font(font)
                .foregroundColor(strokeColor)
                .offset(x: -strokeWidth, y: -strokeWidth)

            Text(text)
                .font(font)
                .foregroundColor(strokeColor)
                .offset(x: strokeWidth, y: -strokeWidth)

            Text(text)
                .font(font)
                .foregroundColor(strokeColor)
                .offset(x: -strokeWidth, y: strokeWidth)

            Text(text)
                .font(font)
                .foregroundColor(strokeColor)
                .offset(x: strokeWidth, y: strokeWidth)

            // Основной текст
            Text(text)
                .font(font)
                .foregroundColor(textColor)
        }
    }
}
