//
//  ListElement.swift
//  CloudKitSwiftUI
//
//  Created by Nigel Gee on 05/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation
import CloudKit

struct ListElement: Identifiable, Hashable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var title: String = ""
    var text: String = ""
    var isEnable: Bool = true
    var types: [String] = []
    var category: CKRecord.Reference?
}
