//
//  Contact.swift
//  ContactsMix
//
//  Created by Abraham Duran on 8/11/25.
//

import Foundation

@objcMembers
public final class Contact: NSObject, NSSecureCoding, Identifiable {
    public static let supportsSecureCoding = true

    public let identifier: String
    public var firstName: String
    public var lastName: String
    public var phone: String
    public var imageUrl: String?

    public var fullName: String { "\(firstName) \(lastName)" }

    public init(identifier: String = UUID().uuidString, firstName: String, lastName: String, phone: String, imageUrl: String? = nil) {
        self.identifier = identifier
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.imageUrl = imageUrl
    }

    // MARK: - NSSecureCoding
    required convenience public init?(coder: NSCoder) {
        guard let id = coder.decodeObject(of: NSString.self, forKey: "id") as String?,
              let first = coder.decodeObject(of: NSString.self, forKey: "firstName") as String?,
              let last = coder.decodeObject(of: NSString.self, forKey: "lastName") as String?,
              let phone = coder.decodeObject(of: NSString.self, forKey: "phone") as String? else {
            return nil
        }
        let image = coder.decodeObject(of: NSString.self, forKey: "image") as String?
        self.init(identifier: id, firstName: first, lastName: last, phone: phone, imageUrl: image)
    }

    public func encode(with coder: NSCoder) {
        coder.encode(identifier as NSString, forKey: "id")
        coder.encode(firstName as NSString, forKey: "firstName")
        coder.encode(lastName as NSString, forKey: "lastName")
        coder.encode(phone as NSString, forKey: "phone")
        if let imageUrl {
            coder.encode(imageUrl as NSString, forKey: "image")
        }
    }
}
