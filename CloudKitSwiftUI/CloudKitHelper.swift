//
//  CloudKitHelper.swift
//  CloudKitSwiftUI
//
//  Created by Nigel Gee on 05/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import Foundation
import CloudKit

struct CloudKitHelper {
    //MARK: - record types
    struct RecordType {
        static let Items = "Items"
        static let Categories = "Categories"
    }
    //MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    // MARK: - saving to CloudKit
    static func saveCategory(category: Category, completion: @escaping (Result<Category, Error>) -> ()) {
        let categoryRecord = CKRecord(recordType: RecordType.Categories)
        categoryRecord["name"] = category.name as CKRecordValue
        categoryRecord["order"] = category.order as CKRecordValue

        CKContainer.default().publicCloudDatabase.save(categoryRecord) { (record, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let record = record else {
                completion(.failure(CloudKitHelperError.recordFailure))
                return
            }

            let recordID = record.recordID

            guard
                let name = record["name"] as? String,
                let order = record["order"] as? Int
                else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }

//            guard let order = record["order"] as? Int else {
//                completion(.failure(CloudKitHelperError.castFailure))
//                return
//            }

            let element = Category(recordID: recordID, order: order, name: name)

            DispatchQueue.main.async {
                completion(.success(element))
            }
        }
    }
    
    static func saveItem(item: ListElement, completion: @escaping (Result<ListElement, Error>) -> ()) {
        let categoryRecord = CKRecord(recordType: RecordType.Categories)
        let itemRecord = CKRecord(recordType: RecordType.Items)
        itemRecord["text"] = item.text as CKRecordValue
        itemRecord["title"] = item.title as CKRecordValue
        itemRecord["isEnable"] = item.isEnable as CKRecordValue
        itemRecord["types"] = item.types as CKRecordValue
        itemRecord["category"] = CKRecord.Reference(record: categoryRecord, action: .deleteSelf)
        
        CKContainer.default().publicCloudDatabase.save(itemRecord) { (record, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let record = record else {
                completion(.failure(CloudKitHelperError.recordFailure))
                return
            }
            
            let id = record.recordID
        
            guard
                let text = record["text"] as? String,
                let title = record["title"] as? String,
                let isEnable = record["isEnable"] as? Bool,
                let types = record["types"] as? [String],
                let category = record["category"] as? CKRecord.Reference
                else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            
            let element = ListElement(recordID: id, title: title, text: text, isEnable: isEnable, types: types, category: category)
            
            DispatchQueue.main.async {
                completion(.success(element))
            }
        }
    }
    
    // MARK: - fetching from CloudKit
    static func fetchCategory(completion: @escaping (Result<Category, Error>) -> ()) {
        let predicate = NSPredicate(value: true)
        let order = NSSortDescriptor(key: "order", ascending: true)
        let name = NSSortDescriptor(key: "name", ascending: true)
        let query = CKQuery(recordType: RecordType.Categories, predicate: predicate)
        query.sortDescriptors = [order, name]
        
        let operation = CKQueryOperation(query: query)
        
        CKContainer.default().publicCloudDatabase.add(operation)
        
        operation.recordFetchedBlock = { record in
            
            let recordID = record.recordID
            
            guard
                let order = record["order"] as? Int,
                let name = record["name"] as? String
                else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
                        
            let category = Category(recordID: recordID, order: order, name: name)
            
            DispatchQueue.main.async {
                completion(.success(category))
            }
        }
    }
    
//    static func fetch(completion: @escaping (Result<ListElement, Error>) -> ()) {
//        let listElement = ListElement()
//        guard let itemID = listElement.recordID else { return }
//        let recordToMatch = CKRecord.Reference(recordID: itemID, action: .deleteSelf)
//        let predicate = NSPredicate(format: "category == %@", recordToMatch)
//        let query = CKQuery(recordType: RecordType.Items, predicate: predicate)
//        
//        let operation = CKQueryOperation(query: query)
//        
//        operation.recordFetchedBlock = { record in
//            
//            let recordID = record.recordID
//           
//            guard
//                let text = record["text"] as? String,
//                let title = record["title"] as? String,
//                let isEnable = record["isEnable"] as? Bool,
//                let types = record["types"] as? [String],
//                let category = record["category"] as? CKRecord.Reference
//                else {
//                completion(.failure(CloudKitHelperError.castFailure))
//                return
//            }
//
//            let elements = ListElement(recordID: recordID, title: title, text: text, isEnable: isEnable, types: types, category: category)
//
//            DispatchQueue.main.async {
//                completion(.success(elements))
//            }
//        }
//        
//        operation.queryCompletionBlock = { (cursor, error) in
//            DispatchQueue.main.async {
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//            }
//        }
//    }
    
    static func fetch(completion: @escaping (Result<ListElement, Error>) -> ()) {
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        let query = CKQuery(recordType: RecordType.Items, predicate: predicate)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)

        CKContainer.default().publicCloudDatabase.add(operation)

        operation.recordFetchedBlock = { record in

            let id = record.recordID

            guard
                let text = record["text"] as? String,
                let title = record["title"] as? String,
                let isEnable = record["isEnable"] as? Bool,
                let types = record["foodTypes"] as? [String],
                let category = record["category"] as? CKRecord.Reference
                else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }

            let element = ListElement(recordID: id, title: title, text: text, isEnable: isEnable, types: types, category: category)

            DispatchQueue.main.async {
                completion(.success(element))
            }
        }

        operation.queryCompletionBlock = { (_, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
            }
        }
    }
    
    // MARK: - delete from CloudKit
    static func delete(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { (recordID, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let recordID = recordID else {
                completion(.failure(CloudKitHelperError.castFailure))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(recordID))
            }
        }
    }
    
    //MARK: - modify in CloudKit
    static func modifyCategory(item: Category, completion: @escaping (Result<Category, Error>) -> ()) {
        guard let recordID = item.recordID else { return }
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let record = record else { return }
            record["order"] = item.order as CKRecordValue
            record["name"] = item.name as CKRecordValue
            
            CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let record = record else { return }
                let recordID = record.recordID
                guard let order = record["order"] as? Int else { return }
                guard let name = record["name"] as? String else { return }
                
                let category = Category(recordID: recordID, order: order, name: name)
                
                DispatchQueue.main.async {
                    completion(.success(category))
                }
            }
        }
    }
    
    static func modify(item: ListElement, completion: @escaping (Result<ListElement, Error>) -> ()) {
        guard let recordID = item.recordID else { return }
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let record = record else { return }
            record["text"] = item.text as CKRecordValue
            record["title"] = item.title as CKRecordValue
            record["isEnable"] = item.isEnable as CKRecordValue
            record["types"] = item.types as CKRecordValue
            
            CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let record = record else { return }
                let id = record.recordID
                guard let category = record["category"] as? CKRecord.Reference else { return }
                guard let text = record["text"] as? String else { return }
                guard let title = record["title"] as? String else { return }
                guard let isEnable = record["isEnable"] as? Bool else { return }
                guard let types = record["types"] as? [String] else { return }
                
                let element = ListElement(recordID: id, title: title, text: text, isEnable: isEnable, types: types, category: category)
                
                DispatchQueue.main.async {
                    completion(.success(element))
                }
            }
        }
    }
}




