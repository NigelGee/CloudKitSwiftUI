//
//  HomeView.swift
//  CloudKitSwiftUI
//
//  Created by Nigel Gee on 08/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var listElements: ListElements
        
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(listElements.items.filter(\.isEnable), id:\.id) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {

                                    Text(item.title)
                                        .font(.headline)

                                    HStack {
                                        ForEach(item.types, id: \.self) { type in
                                            Text(type)
                                                .fontWeight(.black)
                                                .badgesStyle(text: type)
                                        }
                                    }
                                }
                                Spacer()
                                Text("£\(item.text)")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Items")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
