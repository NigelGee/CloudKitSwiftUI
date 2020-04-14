//
//  EditItemView.swift
//  CloudKitSwiftUI
//
//  Created by Nigel Gee on 07/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI

struct EditItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var listElements = ListElements()
    @State var item: ListElement
   
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading) {
                    Toggle(isOn: $item.isEnable) {
                        Text("Enable")
                    }
                    Text("Edit Title")
                        .font(.caption)
                    TextField("Edit Title", text: $item.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Edit Text")
                        .font(.caption)
                    TextField("Edit Text", text: $item.text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        ForEach(item.types, id: \.self) { type in
                            Text(type)
                                .fontWeight(.black)
                                .badgesStyle(text: type)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationBarTitle("Edit Item", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel"){
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done"){
                    self.modify()
                })
        }
    }
    
//    MARK: - Modify to CloudKit
    private func modify() {
        CloudKitHelper.modify(item: self.item) { result in
              switch result {
              case .success(let item):
                  for i in 0..<self.listElements.items.count {
                      let currentItem = self.listElements.items[i]
                      if currentItem.recordID == item.recordID {
                          self.listElements.items[i] = item
                      }
                  }
                  print("Success modify item")
              case .failure(let error):
                  print(error.localizedDescription)
              }
          }
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: ListElement())
    }
}
