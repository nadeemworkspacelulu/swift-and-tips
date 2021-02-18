//
//  PinCodeField.swift
//  UIViewRepresentableDemo
//
//  Created by Pedro Rojas on 17/02/21.
//

import SwiftUI

struct PinCodeField: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        let spacing = 20
        textfield.keyboardType = .numberPad
        textfield.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        textfield.textColor = .red
        textfield.defaultTextAttributes.updateValue(spacing, forKey: .kern)
        textfield.attributedPlaceholder = NSAttributedString(string: "______", attributes: [.kern: spacing])
        textfield.delegate = context.coordinator
        textfield.contentHorizontalAlignment = .fill

        return textfield
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

extension PinCodeField {

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PinCodeField
        let maxLength = 6

        init(_ parent: PinCodeField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            print("text(current text): \(text.count)")
            print("string (added): \(string.count)")
            print("range (deleted): \(range.length)")

            if newLength == maxLength  {
                textField.text = textField.text! + string
                textField.resignFirstResponder()
            }

            return newLength <= maxLength
        }



    }
}