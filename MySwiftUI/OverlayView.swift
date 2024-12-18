//
//  ContentView.swift
//  MySwiftUI
//
//  Created by sakuragi on 2024/12/14.
//

import SwiftUI

struct OverlayView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
                .frame(width: 200, height: 100)
                .overlay(alignment: .topLeading) { Star(color: .red) }
                .overlay(alignment: .topTrailing) { Star(color: .yellow) }
                .overlay(alignment: .bottomLeading) { Star(color: .green) }
                .overlay(alignment: .bottomTrailing) { Star(color: .blue) }
        
             Color.blue
                 .frame(width: 200, height: 200)
                 .overlay {
                     Circle()
                         .frame(width: 100, height: 100)
                     Star()
                 }
        
             Color.blue
                 .frame(width: 200, height: 200)
                 .overlay(alignment: .bottom) {
                     Circle()
                         .frame(width: 100, height: 100)
                     Star()
                 }
        
        Color.blue
              .frame(width: 200, height: 200)
              .overlay(alignment: .bottom) {
                  ZStack(alignment: .bottom) {
                      Circle()
                          .frame(width: 100, height: 100)
                      Star()
                  }
              }
    }
}

struct Star: View {
    var color: Color = .yellow
    var body: some View {
        Image(systemName: "star.fill")
            .foregroundStyle(color)
            
    }
}

#Preview {
    OverlayView()
}
