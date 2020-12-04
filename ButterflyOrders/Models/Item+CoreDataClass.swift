//
//  Item+CoreDataClass.swift
//  ButterflyOrders
//
//  Created by Cristina Rodriguez on 2/12/20.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject, Codable {
    private enum CodingKeys: String, CodingKey { case id, quantity, last_updated_user_entity_id }
    
        // 'required' is needed for Decodable conformance
        // 'convenice' to call self.init(entity:, insertInto)
        required convenience public init(from decoder: Decoder) throws {

            // first get the context again
            guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else {
                self.init()
                return
            }

            // then the entity we want to decode into
            guard let entity = NSEntityDescription.entity(forEntityName: "Item", in: context) else {
                self.init()
                return
            }

            // init self with the entity and context we just got
            self.init(entity: entity, insertInto: context)

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.id = try container.decode(Int64.self, forKey: .id)
            self.quantity = try container.decode(Int64.self, forKey: .quantity)
            self.last_updated_user_entity_id = try container.decode(Int64.self, forKey: .last_updated_user_entity_id)
        }
    
    public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(id, forKey: .id)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(last_updated_user_entity_id, forKey: .last_updated_user_entity_id)
        }
}
