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
public class Invoice: NSManagedObject, Codable {
    
//    required public init?(coder: NSCoder) {
//            
//            // NSCoding
//            //name = coder.decodeObject(forKey: "name") as? String ?? ""
//            //last_name = coder.decodeObject(forKey: "last_name") as? String ?? ""
//            
//            // NSSecureCoding
////        id = try container.decode(Int64.self, forKey: .id)
////        invoice_number = try container.decode(String.self, forKey: .invoice_number)
////        received_status = try container.decode(Int64.self, forKey: .received_status)
////        receipts = try container.decode([Receipt].self, forKey: .receipts)
//        id = coder.decodeObject(of: NSInteger.self, forKey: "id") as! Int64
//        invoice_number = coder.decodeObject(of: NSString.self, forKey: "invoice_number") as String? ?? ""
//        received_status = coder.decodeObject(of: NSInteger.self, forKey: "received_status") as! Int64? ?? ""
//        receipts = coder.decodeObject(of: [Receipt].self, forKey: "receipts") as! [Receipt]? ?? ""
//        }
//        
//    public func encode(with coder: NSCoder) {
//            coder.encode(id, forKey: "id")
//            coder.encode(invoice_number, forKey: "invoice_number")
//        coder.encode(received_status, forKey: "received_status")
//        coder.encode(receipts, forKey: "receipts")
//        }
//    public func encode(with coder: NSCoder) {
////        // first we need to get the context again
////        guard let context = coder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else {
////            self.init()
////            return
////        }
////
////        // then the entity we want to decode into
////        guard let entity = NSEntityDescription.entity(forEntityName: "Invoice", in: context) else {
////            self.init()
////            return
////        }
////
////        // init self with the entity and context we just got
////        self.init(entity: entity, insertInto: context)
////
////        let container = coder.container(keyedBy: CodingKeys.self)
////
////        try container.coder(Int64.self, forKey: .id)
////        try container.coder(String.self, forKey: .invoice_number)
////        try container.coder(Int64.self, forKey: .received_status)
////        try container.coder([Receipt].self, forKey: .receipts)
//    }
//
//    public required convenience init?(coder: NSCoder) {
////        // first we need to get the context again
////        guard let context = coder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else {
////            self.init()
////            return
////        }
////
////        // then the entity we want to decode into
////        guard let entity = NSEntityDescription.entity(forEntityName: "Invoice", in: context) else {
////            self.init()
////            return
////        }
////
////        // init self with the entity and context we just got
////        self.init(entity: entity, insertInto: context)
////
////        let container = try coder.container(keyedBy: CodingKeys.self)
////
////        self.id = try container.decode(Int64.self, forKey: .id)
////        self.invoice_number = try container.decode(String.self, forKey: .invoice_number)
////        self.received_status = try container.decode(Int64.self, forKey: .received_status)
////        self.receipts = try container.decode([Receipt].self, forKey: .receipts)
//
//        var container = coder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(id, forKey: .id)
//        try container.encode(invoice_number, forKey: .invoice_number)
//    try container.encode(received_status, forKey: .received_status)
//    try container.encode(receipts, forKey: .receipts)
//    }
    
    
    public static var supportsSecureCoding = true
    private enum CodingKeys: String, CodingKey { case id, invoice_number, received_status, receipts }
    
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

            self.id = try container.decode(Int64.self, forKey: .id)
            self.invoice_number = try container.decode(String.self, forKey: .invoice_number)
            self.received_status = try container.decode(Int64.self, forKey: .received_status)
            self.receipts = try container.decode([Receipt].self, forKey: .receipts)
        }
    
    public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(id, forKey: .id)
            try container.encode(invoice_number, forKey: .invoice_number)
        try container.encode(received_status, forKey: .received_status)
        try container.encode(receipts, forKey: .receipts)
        }
}
