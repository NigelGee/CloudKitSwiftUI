//
//  ItemDetailView.swift
//  CloudKitSwiftUI
//
//  Created by Nigel Gee on 08/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct ItemDetailView: View {
    var item: ListElement
    
    var body: some View {
        VStack {
            Text("\(item.text)")
                .font(.largeTitle)
        }
        .navigationBarTitle("\(item.title)", displayMode: .inline)
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item: ListElement())
    }
}
