//
//  TabBarView.swift
//  CloudKitSwiftUI
//
//  Created by Nigel Gee on 08/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

struct TabBarView: View {
    @EnvironmentObject var listElements: ListElements
    @EnvironmentObject var listCategories: Categories

    var body: some View {
        TabView {
            VenueView()
                .tabItem {
                    Image(systemName: "house.fill")
            }
            
            HomeView()
                .tabItem {
                    Image(systemName: "doc.plaintext")
            }
            
            AddCategoryView()
                .tabItem {
                    Image(systemName: "doc")
            }
            
            ContentView()
                .tabItem {
                    Image(systemName: "gear")
            }
        }
        .onAppear(perform: fetch)
    }
//MARK: - Fetch from CloudKit
    private func fetch() {
    
//        CloudKitHelper.fetch { result in
//            switch result {
//            case .success(let newItem):
//                self.listElements.items.append(newItem)
//                print("success fetched item")
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        
        CloudKitHelper.fetchCategory { results in
            switch results {
            case .success(let newCategory):
                self.listCategories.categories.append(newCategory)
                print("success fetched category")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
