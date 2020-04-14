//
//  Modifiers.swift
//  CloudKitSwiftUI
//
//  Created by Nigel Gee on 14/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct Badges: ViewModifier {
    var text: String
    
    static let colors: [String: Color] = ["GF": .orange, "VE": .red, "VG": .green, "OR": .blue, "HL": .black]
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .padding(4)
            .background(Self.colors[text, default: .black])
            .clipShape(Circle())
            .foregroundColor(.white)
    }
}

extension View {
    func badgesStyle(text: String) -> some View {
        self.modifier(Badges(text: text))
    }
}
