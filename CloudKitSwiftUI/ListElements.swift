//
//  ListElements.swift
//  CloudKitSwiftUI
//
//  Created by Nigel Gee on 05/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation

class ListElements: ObservableObject {
    @Published var items: [ListElement] = []
}
