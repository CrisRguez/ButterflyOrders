//
//  Invoice+CoreDataClass.swift
//  ButterflyOrders
//
//  Created by Cristina Rodriguez on 2/12/20.
//
//

import Foundation
import CoreData

@objc(Invoice)
public class Invoice: NSManagedObject, Decodable {
    private enum CodingKeys: String, CodingKey { case id, invoice_number, received_status, receipts}
    
        // 'required' is needed for Decodable conformance
        // 'convenice' to call self.init(entity:, insertInto)
        required convenience public init(from decoder: Decoder) throws {

            // first we need to get the context again
            guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else {
                self.init()
                return
            }

            // then the entity we want to decode into
            guard let entity = NSEntityDescription.entity(forEntityName: "Invoice", in: context) else {
                self.init()
                return
            }

            // init self with the entity and context we just got
            self.init(entity: entity, insertInto: context)

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(UUID.self, forKey: .id)
            self.invoice_number = try container.decode(Int64.self, forKey: .invoice_number)
            self.received_status = try container.decode(Int64.self, forKey: .received_status)
            self.receipts = try container.decode([Receipt].self, forKey: .receipts)
        }
}
