//
//  Card.swift
//  MySwiftUI
//
//  Created by sakuragi on 2024/12/14.
//

import SwiftUI

struct Card: Identifiable {
    var id: String = UUID().uuidString
    var number: String
    var expires: String
    var color: Color

    /// Custom Matched Geometry IDs
    var visaGeometryID: String {
        "VISA_\(id)"
    }
}

var cards: [Card] = [
    .init(number: "**** **** **** 1234", expires: "02/27", color: .blue),
    .init(number: "**** **** **** 5678", expires: "06/27", color: .indigo),
    .init(number: "**** **** **** 4575", expires: "09/17", color: .pink),
    .init(number: "**** **** **** 9876", expires: "01/11", color: .black)
]
