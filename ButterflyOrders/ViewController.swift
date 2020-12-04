//
//  ViewController.swift
//  ButterflyOrders
//
//  Created by Cristina Rodriguez on 1/12/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchJson()
    }
    
    let jsonUrl = "https://my-json-server.typicode.com/butterfly-systems/sample-data/purchase_orders"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var purchaseOrders:[PurchaseOrder]?
    
    //    struct DemoData: Codable {
    //        let id: Int
    //        let issue_date: Date
    //    }
    
    //    private func parse(jsonData: Data) {
    //        do {
    //            let decodedData = try JSONDecoder().decode([DemoData].self, from: jsonData)
    //
    ////            print("Title: ", decodedData.id)
    ////            print("Description: ", decodedData.suppli)
    //            print("===================================")
    //        } catch {
    //            print("decode error")
    //        }
    //    }
    
    func fetchJson() {
        loadJson(fromURLString: jsonUrl) { (result) in
            switch result {
            case .success(let data):
                self.loadData(jsonData: data)
//                self.parse(jsonData: data)
            
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
    
    func fetchData() {
        do {
            let purchaseOrdersLocal = try context.fetch(PurchaseOrder.fetchRequest())
            
            if let purchaseOrdersLocal = purchaseOrdersLocal as? [PurchaseOrder]{
                if !purchaseOrdersLocal.isEmpty{
                    purchaseOrders = purchaseOrdersLocal
                    print("coreData result : \(purchaseOrdersLocal)")
                }else{
                    print("No record in PurchaseOrders entity")
                }
                
            }
            
        } catch {
            print("Error")
        }
    }
    
    
    func loadData(jsonData: Data) {
        fetchData()
        
        let decoder = JSONDecoder()
        
        // add context to the decoder so the data can decode itself into Core Data
        // since we added the 'CodingUserInfoKey.context' property we know it's not nil, so force-unwrapping is fine
        decoder.userInfo[CodingUserInfoKey.context!] = self.context
        
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedData = try? decoder.decode([PurchaseOrder].self, from: jsonData)
        
        let purchaseOrderRemote = decodedData?.first as PurchaseOrder?
        let lastUpdatedRemote = (purchaseOrderRemote?.last_updated)!
        
        do {
//            let purchaseOrdersLocal = try context.fetch(PurchaseOrder.fetchRequest()) as [PurchaseOrder]
            let index = purchaseOrders?.firstIndex(where: { $0.last_updated! >= lastUpdatedRemote })
            if index == nil {
                try self.context.save()
                fetchData()
            }
            
            DispatchQueue.main.async {
                // TODO: update table view
            }
        } catch {
            print("error ")
        }
    }
    
    
    
//    func batchInsertExamples() {
//
//            var objectsToInsert: [[String : Any]] = []
//            for i in 0...5 {
//                objectsToInsert.append(["id" : i, "name" : "My Name"])
//            }
//
////            context.performAndWait {
//                do {
//                    let insertRequest = NSBatchInsertRequest(entity: PurchaseOrder.entity(), objects: objectsToInsert)
//                    let insertResult = try context.execute(insertRequest) as! NSBatchInsertResult
//
//                    let success = insertResult.result as! Bool
//                    if !success {
//                        print("batch insert was not successful")
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//
//        if self.context.hasChanges {
//                    do {
//                        try context.save()
//                    } catch {
//                        print("Error: \(error)\nCould not save Core Data context.")
//                        return
//                    }
//                }
////            }
//        }

//        lazy var persistentContainer: NSPersistentContainer = {
//            let container = NSPersistentContainer(name: "nsbatchinsert")
//            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//                if let error = error as NSError? {
//                    fatalError("Unresolved error \(error), \(error.userInfo)")
//                }
//
//                container.viewContext.automaticallyMergesChangesFromParent = true
//                container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//                container.viewContext.undoManager = nil
//                container.viewContext.shouldDeleteInaccessibleFaults = true
//
//            })
//            return container
//        }()
}

//public class CoreItem: NSManagedObject, Identifiable {
//    @NSManaged public var name: String
//    @NSManaged public var id: Int16
//
//}
//
//extension CoreItem {
//
//    static func getAllCoreItems() -> NSFetchRequest <CoreItem> {
//        let request:NSFetchRequest<CoreItem> = CoreItem.fetchRequest() as!
//        NSFetchRequest<CoreItem>
//
//        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
//
//        return request
//    }
//}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
