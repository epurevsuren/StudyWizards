//
//  ChatView.swift
//  StudyWizards
//
//  Created by Purevsuren Erdene on 20/6/2024.
//

import SwiftUI

enum PDFFile: String, CaseIterable {
        case businessStatistics = "BusinessStatistics.pdf"
        case MicroEconomics = "MicroEconomics.pdf"
       // case researchPaper = "ResearchPaper.pdf"
        // Add more PDF files as needed
        
        var fileName: String {
            self.rawValue
        }
    }

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var newMessageText: String = ""
    @State private var showingAttachmentPicker = false
    @State private var selectedTopic: PDFFile = .businessStatistics // Default selected topic
    @State private var selectedAttachment: Attachment?
    
    var body: some View {
        VStack {
            // Dropdown (Picker) for selecting PDF topics
                        Picker(selection: $selectedTopic, label: Text("Select PDF Topic")) {
                            ForEach(PDFFile.allCases, id: \.self) { topic in
                                Text(topic.rawValue)
                                    .tag(topic)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
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
    
    private func fetchAutomaticResponse(for message: Message) {
        guard let url = URL(string: "http://127.0.0.1:5000/ask_question") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["question": message.text, "file_name": selectedTopic.rawValue]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            if let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let responseText = responseDict["answer"] as? String {
                let botMessage = Message(sender: "Bot", text: responseText, date: Date(), attachment: nil)
                DispatchQueue.main.async {
                    messages.append(botMessage)
                }
            }
        }.resume()
    }
    
    private func sendMessage() {
        guard !newMessageText.isEmpty || selectedAttachment != nil else { return }
        
        let userMessage = Message(sender: "User", text: newMessageText, date: Date(), attachment: selectedAttachment)
        messages.append(userMessage)
        newMessageText = ""
        selectedAttachment = nil
        
        fetchAutomaticResponse(for: userMessage)
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
            if let botText = message.textFromBot {
                            Text(botText)
                                .foregroundColor(.green) // or any other style to differentiate
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
