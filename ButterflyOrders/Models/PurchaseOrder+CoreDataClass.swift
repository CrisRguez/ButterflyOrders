//
//  PurchaseOrder+CoreDataClass.swift
//  ButterflyOrders
//
//  Created by Cristina Rodriguez on 2/12/20.
//
//

import Foundation
import CoreData

@objc(PurchaseOrder)
public class PurchaseOrder: NSManagedObject, Decodable {
    private enum CodingKeys: String, CodingKey { case id, purchase_order_number, last_updated, items, invoices}
    
//        public required convenience init(from decoder: Decoder) throws {
//           guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("Error: NSManagedObjectContext not available") }
//           let entity = NSEntityDescription.entity(forEntityName: "PurchaseOrder", in: context)!
//           self.init(entity: entity, insertInto: context)
//           let values = try decoder.container(keyedBy: CodingKeys.self)
//           name = try values.decode(String.self, forKey: .name)
//           id = try values.decode(Int16.self, forKey: .id)
//        }
    
        // 'required' is needed for Decodable conformance
        // 'convenice' to call self.init(entity:, insertInto)
        required convenience public init(from decoder: Decoder) throws {

            // first we need to get the context again
            guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else {
                self.init()
                return
            }

            // then the entity we want to decode into
            guard let entity = NSEntityDescription.entity(forEntityName: "PurchaseOrder", in: context) else {
                self.init()
                return
            }

            // init self with the entity and context we just got
            self.init(entity: entity, insertInto: context)

            // as usual we need a container, I skipped creating the CodingKeys enum since that should be trivial
            let container = try decoder.container(keyedBy: CodingKeys.self)

            // the rest is just doing the actual decoding, finally
            // I decided to remove the '?' from the properties in the classes of my entities since I know the data will be there
            self.id = try container.decode(UUID.self, forKey: .id)
            self.purchase_order_number = try container.decode(Int64.self, forKey: .purchase_order_number)
            self.last_updated = try container.decode(Date.self, forKey: .last_updated)
            // if you wanted to leave them option and use wrappers, just use 'decodeIfPresent' instead of just 'decode'

            // for tags I just decode the data first, then save it into the entities property
            // for items I decode it as an array, then create an NSSet from that array
            // of course this requires that 'Item' conforms to decodable too
            let itemsArray = try container.decode([Item].self, forKey: .items)
            self.items = NSSet(array: itemsArray)//itemsArray.joined(separator: ", ")
            self.invoices = try container.decode([Invoice].self, forKey: .invoices)
        }
}
