//
//  GeometryReaderView.swift
//  MySwiftUI
//
//  Created by sakuragi on 2024/12/12.
//

import SwiftUI

struct GeometryReaderView: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(.teal)
                .frame(height: 200)
            GeometryReader { proxy in
                Rectangle()
                    .fill(.green)
                VStack(alignment: .leading) {
                    Text("\(proxy.frame(in: .local).debugDescription)")
                    Text("\(proxy.frame(in: .global).debugDescription)")
                    Text("\(proxy.frame(in: .local).midX)")
                    Text("\(proxy.frame(in: .local).midY)")
                    Text("\(proxy.frame(in: .local).minX)")
                    Text("\(proxy.frame(in: .local).minY)")
                }

                Text("Where am I ")

                    .position(x: proxy.frame(in: .local).minX,
                              y: proxy.frame(in: .local).midY)

            }
        }
    }
}

#Preview {
    GeometryReaderView()
}
