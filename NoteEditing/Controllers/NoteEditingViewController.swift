//
//  NoteEditingViewController.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 05.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

class NoteEditingViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var destoryDateSwitch: UISwitch!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    private(set) var note: Note?
    
    // MARK: Private properties
    private var destoryDate: Date?
    private var color: UIColor?
    
    // MARK: Initialization
    init?(coder: NSCoder, note: Note?) {
        self.note = note
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        hideKeyboardWhenTappedAround()
        
        title = note == nil ? "Новая заметка" : "Редактирование"
        setupUI()
    }
    
    // MARK: Private methods
    private func showAlertDestoryDatePicker() {
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
        datePicker.minimumDate = Date().addingTimeInterval(24 * 60 * 60) // current date + one day
        datePicker.date = destoryDate ?? datePicker.minimumDate!
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.view.addSubview(datePicker)
        let selectAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { _ in
            self.destoryDate = datePicker.date
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true) {
            self.destoryDate = datePicker.date
        }
        
    }
    
    private func updateNote() {
        if note == nil {
            note = Note(title: "", content: "", importance: .common, dateOfSelfDestruction: nil)
        }
        note!.title = titleTextField?.text ?? ""
        note!.content = descriptionTextView?.text ?? ""
        note!.dateOfSelfDestruction = destoryDate
        note!.color = color ?? .white
    }
    
    private func setupUI() {
        titleTextField.text = note?.title
        descriptionTextView.text = note?.content
        destoryDate = note?.dateOfSelfDestruction
        destoryDateSwitch.isOn = note?.dateOfSelfDestruction != nil
        color = note?.color
    }
    
}
// MARK: - TableViewControllerDelegate
extension NoteEditingViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard destoryDateSwitch.isOn else { return }
        showAlertDestoryDatePicker()
    }
    
}

// MARK: - Actions
extension NoteEditingViewController {
    
    @IBAction func actionDestoryDate(_ sender: UISwitch) {
        guard sender.isOn else {
            destoryDate = nil
            return
        }
        showAlertDestoryDatePicker()
    }
    
}

// MARK: - Navigation
extension NoteEditingViewController {
    
    @IBSegueAction private func showColorsTable(coder: NSCoder) -> ColorsCollectionViewController? {
            ColorsCollectionViewController(coder: coder, color: note?.color ?? .white, delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveAndBack" {
            updateNote()
        }
    }
    
}

// MARK: - ColorsCollectionViewControllerDelegate
extension NoteEditingViewController: ColorsCollectionViewControllerDelegate {
    
    func didChangeColor(_ color: UIColor) {
        self.color = color
    }
    
}

// MARK: - TextFieldDelegate
extension NoteEditingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTextView.becomeFirstResponder()
        return true
    }
    
}
