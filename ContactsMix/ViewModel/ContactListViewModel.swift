//
//  ContactListViewModel.swift
//  ContactsMix
//
//  Created by Abraham Duran on 8/11/25.
//

import Foundation

@objcMembers
public final class ContactListViewModel: NSObject {
    private let store: ContactStore
    private(set) var allContacts: [Contact] = []
    private(set) var filteredContacts: [Contact] = []
    private var query = ""

    public var numberOfItems: Int { filteredContacts.count }

    public convenience override init() {
        self.init(store: UserDefaultsContactStore())
    }

    public init(store: ContactStore) {
        self.store = store
        super.init()
    }

    public func load() {
        allContacts = store.fetch()
        applyFilter()
    }

    public func item(at index: Int) -> Contact? {
        guard index >= 0, index < filteredContacts.count else { return nil }
        return filteredContacts[index]
    }

    public func add(contact: Contact) {
        store.save(contact)
        load()
    }

    public func delete(at index: Int) {
        guard let contact = item(at: index) else { return }
        store.delete(contact)
        load()
    }

    public func updateQuery(_ newQuery: String) {
        query = newQuery
        applyFilter()
    }

    private func applyFilter() {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard query.isEmpty == false else {
            filteredContacts = allContacts
            return
        }

        filteredContacts = allContacts.filter { contact in
            let hay = [contact.fullName, contact.phone]
                .joined(separator: " ")
                .lowercased()
            return hay.contains(query)
        }
    }
}
