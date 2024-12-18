//
//  ScrollAnimation.swift
//  MySwiftUI
//
//  Created by yongyou on 2024/12/18.
//

import SwiftUI
enum Album: String, CaseIterable {
    case charleyrivers, chilkoottrail, hiddenlake, rainbowlake, turtlerock, twinlake, umbagog
}

struct ScrollAnimation: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Album.allCases, id: \.self) { album in
                    albumImage(album: album)
                        .padding(.horizontal, 16)
                        .scrollTransition(topLeading: .animated(.smooth), bottomTrailing: .animated(.smooth), axis: .vertical) { content, phase in
                            content
                                .scaleEffect(1.0 - (abs(phase.value) * 0.08))
                                .blur(radius: 3 * abs(phase.value))
                        }
                }
            }
        }
    }

    func albumImage(album: Album) -> some View {
        Image(album.rawValue)
            .resizable()
            .aspectRatio(1.0, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ScrollAnimation()
}
