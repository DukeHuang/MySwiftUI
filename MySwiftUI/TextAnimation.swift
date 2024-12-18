//
//  TextAnimation.swift
//  MySwiftUI
//
//  Created by yongyou on 2024/12/18.
//

import SwiftUI

struct TextAnimation: View {
    var items = ["Buttons","Text","Images","Cards", "Forms"]
    var colors: [Color] = [.blue, .indigo, .red, .cyan, .yellow]
    @State var currentIndex = 0

    var customTransition: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .offset(y: 50).combined(with: .opacity),
            removal: .offset(y: -50).combined(with: .opacity)
        )
    }
    var body: some View {
        HStack(spacing: 4) {
            Text("Loading")
            ZStack {
                ForEach(0..<items.count,id:\.self) { index in
                    if index == currentIndex {
                        Text(items[index])
                            .bold()
                            .foregroundStyle(colors[index])
                            .transition(customTransition.combined(with: .scale(scale: 1.5, anchor: .leading)))
                            .id(index)
                            .border(.black)
                    }
                }
            }
            .frame(width: 70,height: 30, alignment: .leading)
            .clipped()
        }
        .onAppear {
            startTimer()
        }
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 2.5)) {
                currentIndex = (currentIndex + 1) % items.count
                print(currentIndex)
            }
        }
    }
}

#Preview {
    TextAnimation()
}
