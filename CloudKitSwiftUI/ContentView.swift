//
//  ContentView.swift
//  CloudKitSwiftUI
//
//  Created by Nigel Gee on 05/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @EnvironmentObject var listElements: ListElements
    @EnvironmentObject var listCategories: Categories
    @State private var item = ListElement()
    @State private var showingSheet = false
    @State private var showingEditItemView = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(listElements.items, id:\.id) { item in
                        HStack(spacing: 15) {
                            HStack {
                                Text(item.title)
                                Spacer()
                                Text("£\(item.text)")
                            }
                            .foregroundColor(item.isEnable ? .primary : .secondary)
                        }
                        .onTapGesture(count: 2, perform: {
                            self.item = item
                            self.showingEditItemView = true
                            self.showingSheet.toggle()
                        })
                    }
                    .onDelete(perform: deleteItem)
                }
            }
            .navigationBarTitle("Items", displayMode: .inline)
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingEditItemView = false
                self.showingSheet.toggle()
            }){
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showingSheet) {
            if self.showingEditItemView {
                EditItemView(listElements: self.listElements, item: self.item)
            } else {
                AddItemView(listElements: self.listElements, listCategories: self.listCategories)
            }
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let indexNumber = indexSet.first else { return }
        guard let recordID = listElements.items[indexNumber].recordID else { return }
        CloudKitHelper.delete(recordID: recordID) { result in
            switch result {
            case .success(let recordID):
                self.listElements.items.removeAll {(listElements) -> Bool in
                    return listElements.recordID == recordID
                }
                print("success deleted item")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
