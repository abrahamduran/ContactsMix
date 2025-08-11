//
//  AddContactFactory.swift
//  ContactsMix
//
//  Created by Abraham Duran on 8/11/25.
//

import Foundation
import UIKit
import SwiftUI

@objcMembers
public final class AddContactFactory: NSObject {
    @MainActor public class func make(onCancel: @escaping () -> Void, onSave: @escaping (Contact) -> Void) -> UIViewController {
        let view = AddContactView(onCancel: onCancel, onSave: onSave)
        return UIHostingController(rootView: view)
    }
}
