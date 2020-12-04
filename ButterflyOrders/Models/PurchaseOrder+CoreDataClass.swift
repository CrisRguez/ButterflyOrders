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
public class PurchaseOrder: NSManagedObject, Codable {
    private enum CodingKeys: String, CodingKey { case id, purchase_order_number, last_updated, items, invoices }
    
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
            self.id = try container.decode(Int64.self, forKey: .id)
            let purchaseOrderString = try container.decode(String.self, forKey: .purchase_order_number)
            self.purchase_order_number = Int64(purchaseOrderString)!
            let lastUpdateString = try container.decode(String.self, forKey: .last_updated)
            
            let myFormatter = DateFormatter()
            // Let’s define the format for date strings we want to parse:
            myFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            myFormatter.timeZone = TimeZone(abbreviation: "GMT")
            // Here's a date in the specified format.
            // DateFormatter’s date(from:) method will be able to parse it.
            self.last_updated = myFormatter.date(from: lastUpdateString)
            // if you wanted to leave them option and use wrappers, just use 'decodeIfPresent' instead of just 'decode'

            // for tags I just decode the data first, then save it into the entities property
            // for items I decode it as an array, then create an NSSet from that array
            // of course this requires that 'Item' conforms to decodable too
            self.items = try container.decode([Item].self, forKey: .items)
//            self.items = NSSet(array: itemsArray)//itemsArray.joined(separator: ", ")
            self.invoices = try container.decode([Invoice].self, forKey: .invoices)
        }
    
    public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(id, forKey: .id)
        try container.encode(purchase_order_number, forKey: .purchase_order_number)
        try container.encode(last_updated, forKey: .last_updated)
        try container.encode(items, forKey: .items)
        try container.encode(invoices, forKey: .invoices)
        }
}
