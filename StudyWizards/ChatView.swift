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
    
    func generateAutomaticResponse(for message: Message) -> Message? {
        let lowercasedText = message.text.lowercased()
        var responseText: String?

        if lowercasedText.contains("hello") {
            responseText = "Hi there! How can I help you today?"
        } else if lowercasedText.contains("help") {
            responseText = "Sure, what do you need help with?"
        } else if lowercasedText.contains("thank you") {
            responseText = "You're welcome!"
        }

        if let responseText = responseText {
            return Message(sender: "Bot", text: responseText, date: Date(), attachment: nil)
        }
        return nil
    }

    private func sendMessage() {
        guard !newMessageText.isEmpty || selectedAttachment != nil else { return }
        
        let userMessage = Message(sender: "User", text: newMessageText, date: Date(), attachment: selectedAttachment)
        messages.append(userMessage)
        newMessageText = ""
        selectedAttachment = nil

        if let autoResponse = generateAutomaticResponse(for: userMessage) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Simulate response delay
                messages.append(autoResponse)
            }
        }
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
