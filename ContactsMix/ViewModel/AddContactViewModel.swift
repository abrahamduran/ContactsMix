//
//  AddContactViewModel.swift
//  ContactsMix
//
//  Created by Abraham Duran on 8/11/25.
//

import Foundation

@MainActor
@Observable
final class AddContactViewModel: ObservableObject {
    var firstName = ""
    var lastName = ""
    var phone = ""
    var imageUrl: String?

    // Genera URL aleatoria (API pública sin key)
    func loadRandomImage() {
        let seed = UUID().uuidString
        imageUrl = "https://picsum.photos/seed/\(seed)/400"
    }

    var canSave: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phone.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func buildContact() -> Contact {
        Contact(firstName: firstName, lastName: lastName, phone: phone, imageUrl: imageUrl)
    }
}
