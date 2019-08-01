//
//  GallaryCollectionViewController.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 20.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ImageCell"
private let showImageIdentifier = "ShowImage"

class GallaryCollectionViewController: UICollectionViewController {
    
    private var images: [UIImage] = {
        var images: [UIImage] = []
        for i in 1...5 {
            images.append(UIImage(named: "screen_\(i)")!)
        }
        return images
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Private methods
    private func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    private func openGallary() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
}

// MARK: - Actions
extension GallaryCollectionViewController {
    
    @IBAction func actionAddImage(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
}

// MARK: - Navigation
extension GallaryCollectionViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == showImageIdentifier else { return }
        let imagesViewController = segue.destination as! ImagesCollectionViewController
        imagesViewController.images = images
        imagesViewController.currentIndexPath = collectionView.indexPath(for: sender as! UICollectionViewCell) //selectedIndexPath
        
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension GallaryCollectionViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            if let pickedImage = info[.originalImage] as? UIImage {
                self.images.insert(pickedImage, at: 0)
                self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension GallaryCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        
        cell.imageView.image = images[indexPath.item]
        
        return cell
    }
    
}

