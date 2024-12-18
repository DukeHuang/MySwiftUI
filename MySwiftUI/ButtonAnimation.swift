//
//  ButtonAnimation.swift
//  MySwiftUI
//
//  Created by yongyou on 2024/12/18.
//

import SwiftUI

struct ButtonAnimation: View {

    @State private var showDetail = false

    var body: some View {
        Button {
            showDetail.toggle()
        } label: {
            Label("Graph", systemImage: "chevron.right.circle")
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .rotationEffect(.degrees(showDetail ? 90 : 0))
                .scaleEffect(showDetail ? 1.5 : 1)
                .padding()
                .animation(Animation.easeInOut, value: showDetail)
        }
    }
}

#Preview {
    ButtonAnimation()
}
