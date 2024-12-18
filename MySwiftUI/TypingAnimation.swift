//
//  TypingAnimation.swift
//  MySwiftUI
//
//  Created by yongyou on 2024/12/18.
//

import SwiftUI

struct TypingAnimation: View {
    @State var displayedText = ""
    let fullText = "Hello, World!"
    let typingSpeed = 0.15
    @State var showLine = false
    var body: some View {
        HStack {
            Text(displayedText)
                .font(.largeTitle.bold())
            Rectangle()
                .frame(width: 5,height: 40)
                .opacity(showLine ? 1 : 0)
        }
        .foregroundStyle(.green)
//        .onTapGesture {
//            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
//                showLine.toggle()
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                startTyping()
//            }
//        }
        .onAppear {
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
                showLine.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                startTyping()
            }
        }
    }
    func startTyping() {
        displayedText = ""
        for (index, character) in fullText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + typingSpeed * Double(index)) {
                displayedText.append(character)
                if index == fullText.count - 1 {
                    showLine = false
                } else {
                    showLine.toggle()
                }
            }
        }
    }
}

#Preview {
    TypingAnimation()
}
