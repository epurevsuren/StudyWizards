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
    let sender: String
    let text: String
    let date: Date
    let attachment: Attachment?
    var textFromBot: String? // Property to store bot's response

        init(sender: String, text: String, date: Date, attachment: Attachment? = nil, textFromBot: String? = nil) {
            self.sender = sender
            self.text = text
            self.date = date
            self.attachment = attachment
            self.textFromBot = textFromBot
        }
}

struct Attachment: Identifiable {
    let id = UUID()
    let fileName: String
    let fileURL: URL
}
