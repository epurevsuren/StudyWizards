//
//  Message.swift
//  StudyWizards
//
//  Created by Purevsuren Erdene on 20/6/2024.
//

import SwiftUI
import Foundation

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let date: Date
    let attachment: Attachment?
}

struct Attachment: Identifiable {
    let id = UUID()
    let fileName: String
    let fileURL: URL
}
