//
//  CardView.swift
//  MySwiftUI
//
//  Created by sakuragi on 2024/12/18.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            Home(size: size, safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .top)
        }
    }
}

#Preview {
    CardView()
}
