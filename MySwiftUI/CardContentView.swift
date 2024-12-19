//
//  CardContentView.swift
//  MySwiftUI
//
//  Created by sakuragi on 2024/12/16.
//

import SwiftUI

struct CCard: Hashable {
    var name: String = ""
    var number: String = ""
    var cvv: String = ""
    var month: String = ""
    var year: String = ""
}

struct CardContentView: View {
    @State private var card: CCard = .init()
    var body: some View {
        CustomTextField(title: "Card Number", hint: "", value: $card.number) {

        }
    }
}

/// Custom Sectioned TextField
struct CustomTextField: View {
    var title: String
    var hint: String
    @Binding var value: String
    var onChange: () -> Void
    @FocusState private var isActive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.gray)

            TextField(hint, text: $value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .contentShape(.rect)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isActive ? .blue : .gray.opacity(0.5), lineWidth: 1.5)
                        .animation(.snappy, value: isActive)
                }
                .focused($isActive)
        }
    }
}

#Preview {
    CardContentView()
}
