//
//  ChatView.swift
//  StudyWizards
//
//  Created by Purevsuren Erdene on 20/6/2024.
//

import SwiftUI

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var newMessageText: String = ""
    @State private var showingAttachmentPicker = false
    @State private var selectedAttachment: Attachment?

    var body: some View {
        VStack {
            List(messages) { message in
                MessageView(message: message)
            }
            
            HStack {
                TextField("Enter message...", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    showingAttachmentPicker = true
                }) {
                    Image(systemName: "paperclip")
                }
                .padding()

                Button(action: sendMessage) {
                    Text("Send")
                }
                .padding()
            }
            .background(Color(.systemGray6))
        }
        .sheet(isPresented: $showingAttachmentPicker) {
            AttachmentPicker(selectedAttachment: $selectedAttachment)
        }
    }

    private func sendMessage() {
        guard !newMessageText.isEmpty || selectedAttachment != nil else { return }
        let message = Message(text: newMessageText, date: Date(), attachment: selectedAttachment)
        messages.append(message)
        newMessageText = ""
        selectedAttachment = nil
    }
}

struct MessageView: View {
    let message: Message

    var body: some View {
        VStack(alignment: .leading) {
            Text(message.text)
            if let attachment = message.attachment {
                Text("Attachment: \(attachment.fileName)")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        // Handle attachment tap
                    }
            }
            Text("\(message.date, formatter: dateFormatter)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


#Preview {
    ChatView()
}
