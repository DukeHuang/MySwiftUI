//
//  GridView.swift
//  MySwiftUI
//
//  Created by sakuragi on 2024/12/15.
//

import SwiftUI

struct GridView: View {
    private let size: CGFloat = 50
    private let padding: CGFloat = 5
    
    private var columns: [GridItem] {
        return [
            .init(.adaptive(minimum: size, maximum: size))
        ]
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: padding) {
                ForEach((0...79), id: \.self) {
                    let codepoint = $0 + 0x1f600
                    let emoji = String(Character(UnicodeScalar(codepoint)!))
                    Text("\(emoji)")
                        .font(.largeTitle)
                        .frame(width: size, height: size, alignment: .center)
                        .border(Color.primary, width: 1)
                }
            }.padding(padding)
        }
    }
}

#Preview {
    GridView()
}
