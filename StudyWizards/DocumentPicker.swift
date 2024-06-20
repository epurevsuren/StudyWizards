//
//  DocumentPicker.swift
//  StudyWizards
//
//  Created by Purevsuren Erdene on 20/6/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct AttachmentPicker: UIViewControllerRepresentable {
    @Binding var selectedAttachment: Attachment?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: AttachmentPicker

        init(_ parent: AttachmentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            let attachment = Attachment(fileName: url.lastPathComponent, fileURL: url)
            parent.selectedAttachment = attachment
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.selectedAttachment = nil
        }
    }
}
