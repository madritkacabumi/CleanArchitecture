//
//  CTextField.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation
import SwiftUI
import Combine

struct CustomPickerViewRepresentable: UIViewRepresentable {
    
    // MARK: - Properties
    private var dataSet: [String]
    private var onSelectedValue: ((_ value: String) -> Void)
    private var text: String {
        didSet {
            onSelectedValue(text)
        }
    }
    
    // MARK: - Construct
    init(dataSet: [String], text: String, onSelectedValue: @escaping (_: String) -> Void) {
        self.dataSet = dataSet
        self.onSelectedValue = onSelectedValue
        self.text = text
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.frame.size.height = 36
        textField.tintColor = UIColor.clear
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.text = text
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, selectedText: text)
    }
    
    // MARK: - Coordinator
    final class Coordinator: NSObject {
        
        // MARK: - Properties
        var parent: CustomPickerViewRepresentable
        private var selectedText: String = ""
        
        // MARK: - Construct
        init(_ parent: CustomPickerViewRepresentable, selectedText: String) {
            self.parent = parent
            self.selectedText = selectedText
        }
        
        func setPickerType(textField: UITextField) {
            textField.inputView = getPicker()
            if let row = parent.dataSet.firstIndex(of: parent.text) {
                let myPicker = textField.inputView as! UIPickerView
                myPicker.selectRow(row, inComponent: 0, animated: true)
            }
            textField.inputAccessoryView = getToolBar()
        }
        
        private func getPicker() -> UIPickerView {
            let picker = UIPickerView()
            picker.backgroundColor = UIColor.systemBackground
            picker.delegate = self
            picker.dataSource = self
            return picker
        }
        
        private func getToolBar() -> UIToolbar {
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.backgroundColor = UIColor.systemBackground
            toolBar.isTranslucent = true
            toolBar.sizeToFit()
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "key.button.done".localized, style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
            toolBar.setItems([spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            return toolBar
        }
        
        @objc func donePicker() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            self.parent.text = self.selectedText
        }
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension CustomPickerViewRepresentable.Coordinator: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        parent.dataSet.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return parent.dataSet[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedText = parent.dataSet[row]
    }
}

// MARK: - UITextFieldDelegate
extension CustomPickerViewRepresentable.Coordinator: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setPickerType(textField: textField)
        return true
    }
}
