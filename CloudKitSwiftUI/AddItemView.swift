//
//  AddItemView.swift
//  CloudKitSwiftUI
//
//  Created by Nigel Gee on 06/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var listElements: ListElements
    @ObservedObject var listCategories: Categories
    
    @State private var item = ListElement()
    @State private var type = ""
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading) {
                    Section {
                        Toggle(isOn: $item.isEnable) {
                            Text("Enable")
                        }
                    }
                    Section {
                        Picker("Category", selection:$item.category) {
                            ForEach(self.listCategories.categories, id: \.id) {
                                Text($0.name)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        
                        Text("Add New Title")
                            .font(.caption)
                        TextField("(Required)", text: $item.title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Add New Text")
                            .font(.caption)
                        TextField("(Required)", text: $item.text)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Types")
                            .font(.caption)
                        HStack {
                            TextField("GF, VE, VG, OR, HL", text: $type)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Add") {
                                self.item.types.append(self.type.uppercased())
                                self.type = ""
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Add New Item", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Submit"){
                    self.addNewItem()
            })
        }
    }
    
    // MARK: - Save to CloudKit
    private func addNewItem() {
        if !self.item.title.isEmpty {
            let newItem = ListElement(title: self.item.title, text: self.item.text, isEnable: self.item.isEnable, types: self.item.types, category: self.item.category)
            
            CloudKitHelper.saveItem(item: newItem) { result in
                switch result {
                case .success(let item):
                    self.listElements.items.insert(item, at: 0)
                    print("Success added Item")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(listElements: ListElements(), listCategories: Categories())
    }
}
