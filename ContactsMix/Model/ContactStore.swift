//
//  ContactStore.swift
//  ContactsMix
//
//  Created by Abraham Duran on 8/11/25.
//

import Foundation

@objc
public protocol ContactStore {
    func fetch() -> [Contact]
    func save(_ contact: Contact)
    func delete(_ contact: Contact)
}

@objcMembers
public final class UserDefaultsContactStore: NSObject, ContactStore {
    private let key = "contacts_store"
    private let defaults = UserDefaults.standard

    public func fetch() -> [Contact] {
        guard let data = defaults.data(forKey: key) else { return [] }
        do {
            let obj = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Contact.self], from: data)
            return obj as? [Contact] ?? []
        } catch {
            return []
        }
    }
    
    public func save(_ contact: Contact) {
        var storage = fetch()
        if let index = storage.firstIndex(where: { $0.identifier == contact.identifier }){
            storage[index] = contact
        } else {
            storage.append(contact)
        }
        persist(storage)
    }
    
    public func delete(_ contact: Contact) {
        var storage = fetch()
        storage.removeAll(where: { $0.identifier == contact.identifier })
        persist(storage)
    }

    private func persist(_ contacts: [Contact]){
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: contacts, requiringSecureCoding: true)
            defaults.set(data, forKey: key)
        } catch {
            print("Persist error:", error)
        }
    }
}
