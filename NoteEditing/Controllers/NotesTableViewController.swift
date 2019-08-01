//
//  NotesTableViewController.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 19.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

private struct Identifier {
    private init() { }
    static let addNewNoteIdentifier = "AddNewNoteIdentifier"
    static let editNoteIdentifier = "EditNoteIdentifier"
    static let noteCellIdentifier = "NoteCell"
    static let saveAndBackIdentifier = "SaveAndBack"
    static let backIdentifier = "Back"
}

class NotesTableViewController: UITableViewController {
    
    private var notebook = FileNotebook()
    private var notes: Notes {
        get {
            notebook.notes
        }
        set {
            notebook.add(newValue)
        }
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        let activityIndicatorItem = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.rightBarButtonItems?.append(activityIndicatorItem)
        return activityIndicator
    }()
    
    // MARK: Private properties
    private var selectedIndexPath: IndexPath?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    // MARK: Private func
    private func configureCell(_ cell: NoteCell, with note: Note) {
        cell.colorView.backgroundColor = note.color
        cell.titleLabel.text = note.title
        cell.descriptionLabel.text = note.content
    }
    
}

// MARK: - Actions and Navigations
extension NotesTableViewController {
    
    @IBSegueAction private func showEditNote(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> NoteEditingViewController? {
        
        switch segueIdentifier {
        case Identifier.addNewNoteIdentifier:
            selectedIndexPath = nil
            return NoteEditingViewController(coder: coder, note: nil)
        case Identifier.editNoteIdentifier:
            return NoteEditingViewController(coder: coder, note: notes[selectedIndexPath!.row])
        default:
            return nil
        }
        
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        
        guard
            unwindSegue.identifier == Identifier.saveAndBackIdentifier,
            let noteEditingViewController = unwindSegue.source as? NoteEditingViewController,
            let newNote = noteEditingViewController.note else { return }
        
        if var indexPath = selectedIndexPath {   // Update cell
            activityIndicator.startAnimating()
            save(newNote) { index in
                OperationQueue.main.addOperation { [weak self] in
                    indexPath.row = index ?? indexPath.row
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    self?.selectedIndexPath = nil
                    self?.activityIndicator.stopAnimating()
                }
            }
            
        } else {    // Append cell
            activityIndicator.startAnimating()
            save(newNote) { index in
                OperationQueue.main.addOperation { [weak self] in
                    self?.tableView.insertRows(at: [IndexPath(row: index ?? 0, section: 0)], with: .automatic)
                    self?.activityIndicator.stopAnimating()
                }
                
            }
            
        }
        
    }
    
}

// MARK: - Operations
extension NotesTableViewController {
    
    func save(_ note: Note, completion: @escaping (_ index: Int?) -> Void) {
        let saveNoteOperation = SaveNoteOperation(note: note, notebook: notebook, backendQueue: OperationQueue(), dbQueue: OperationQueue()) { result in
            
            guard case let .success(index) = result else { return }
            completion(index)
            
        }
        let commonQueue = OperationQueue()
        
        commonQueue.addOperation(saveNoteOperation)
    }
    
    func removeNote(at uid: String, completion: @escaping (_ index: Int?) -> Void) {
        let removeNoteOperation = RemoveNoteOperation(uid: uid, notebook: notebook, backendQueue: OperationQueue(), dbQueue: OperationQueue()) { result in
            
            guard case let .success(index) = result else { return }
            completion(index)
            
        }
        let commonQueue = OperationQueue()
        commonQueue.addOperation(removeNoteOperation)
    }
    
}

// MARK: - Table view data source AND Table view delegate
extension NotesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.noteCellIdentifier, for: indexPath) as! NoteCell
        
        configureCell(cell, with: notes[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndexPath = indexPath
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            activityIndicator.startAnimating()
            let uid = notes[indexPath.row].uid
            removeNote(at: uid) { (index) in
                OperationQueue.main.addOperation { [weak self] in
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self?.activityIndicator.stopAnimating()
                }
                
            }
            
        }
        
    }
    
}
