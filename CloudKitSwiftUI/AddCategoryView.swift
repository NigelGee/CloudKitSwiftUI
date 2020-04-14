//
//  AddCategoryView.swift
//  CloudKitSwiftUI
//
//  Created by Nigel Gee on 13/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct AddCategoryView: View {
    @EnvironmentObject var listCategory: Categories
    @State private var item = Category()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Category", text: $item.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add") {
                        self.addCategory()
                    }
                    .disabled(item.name.isEmpty)
                }
                .padding([.horizontal, .top])
                
                List {
                    ForEach(listCategory.categories, id: \.id) { item in
                        Text(item.name)
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: moveItem)
                }
            
            }
            .padding(.bottom)
            .navigationBarTitle("Categories", displayMode: .inline)
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func addCategory() {
        let newOrder = (self.listCategory.categories.last?.order ?? 0) + 1
        let newCategory = Category(order: newOrder, name: self.item.name)
        CloudKitHelper.saveCategory(category: newCategory) { result in
            switch result {
            case .success(let newCategory):
                self.listCategory.categories.append(newCategory)
                print("Success added Category")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        item.name = ""
    }
    
    func delete(indexSet: IndexSet) {
        guard let indexNumber = indexSet.first else { return }
        guard let recordID = listCategory.categories[indexNumber].recordID else { return }
        CloudKitHelper.delete(recordID: recordID) { result in
            switch result {
            case .success(let recordID):
                self.listCategory.categories.removeAll {(listCategory) -> Bool in
                    return listCategory.recordID == recordID
                }
                print("success deleted item")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func moveItem(indexSet: IndexSet, destination: Int) {
        guard let source = indexSet.first else { return }

        if source < destination {
            var startIndex = source + 1
            let endIndex = destination - 1
            var startOrder = listCategory.categories[source].order
            while startIndex <= endIndex {
                let recordID = listCategory.categories[startIndex].recordID
                let name = listCategory.categories[startIndex].name
                let order = startOrder
                let newItem = Category(recordID: recordID, order: order, name: name)
                saveModified(item: newItem)
                startOrder += 1
                startIndex += 1
            }
            let recordID = listCategory.categories[source].recordID
            let name = listCategory.categories[source].name
            let order = startOrder
            let newItem = Category(recordID: recordID, order: order, name: name)
            saveModified(item: newItem)
        } else if destination < source {
            var startIndex = destination
            let endIndex = source - 1
            var startOrder = listCategory.categories[destination].order + 1
            let newOrder = listCategory.categories[destination].order
            while startIndex <= endIndex {
                let recordID = listCategory.categories[startIndex].recordID
                let name = listCategory.categories[startIndex].name
                let order = startOrder
                let newItem = Category(recordID: recordID, order: order, name: name)
                saveModified(item: newItem)
                startOrder += 1
                startIndex += 1
            }
            let recordID = listCategory.categories[source].recordID
            let name = listCategory.categories[source].name
            let order = newOrder
            let newItem = Category(recordID: recordID, order: order, name: name)
            saveModified(item: newItem)
        }
    }
    
    func saveModified(item: Category) {
        CloudKitHelper.modifyCategory(item: item) { result in
            switch result {
            case .success(let item):
                for i in 0..<self.listCategory.categories.count {
                    let currentItem = self.listCategory.categories[i]
                    if currentItem.recordID == item.recordID {
                        self.listCategory.categories[i] = item
                    }
                }
                print("success moved")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView()
    }
}
