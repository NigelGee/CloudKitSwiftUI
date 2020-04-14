//
//  Category.swift
//  CloudKitSwiftUI
//
//  Created by Nigel Gee on 12/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation
import CloudKit

struct Category: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var order: Int = 0
    var name: String = ""
}
