//
//  ColorsCollectionViewController.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 06.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

private let reuseIdentifierColorCell = "ColorCell"
private let reuseIdentifierGradientColorCell = "GradientColorCell"

protocol ColorsCollectionViewControllerDelegate: class {
    func didChangeColor(_ color: UIColor)
}

class ColorsCollectionViewController: UICollectionViewController {
    
    private weak var delegate: ColorsCollectionViewControllerDelegate?
    private let color: UIColor
    
    // MARK: Private properties
    private var colors: [UIColor?] = [.white, .red, .green, nil]
    private let colorsForGradientView: [UIColor] = [.red, .yellow, .green, .cyan, .blue, .purple, .red]
    private let gradientViewHorizontalMode: Bool = true
    private var isWillChangeOrientation = false
    
    private var choosingIndexColor = 0
    
    private var choosingColor: UIColor? {
        return colors[choosingIndexColor]
    }
    
    // MARK: Initialization
    init?(coder: NSCoder, color: UIColor, delegate: ColorsCollectionViewControllerDelegate?) {
        self.color = color
        self.delegate = delegate
        super.init(coder: coder)
        
        setupIndexColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewDidDisappear(animated)
    }
    
    // MARK: Private methods
    @objc private func rotated() {
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    private func setupIndexColor() {
        let stringColor = CIColor(color: color).stringRepresentation
        choosingIndexColor = colors.enumerated().first {
            let color = CIColor(color: $1 ?? .white).stringRepresentation
            return color == stringColor
        }?.offset ?? 3
        if choosingIndexColor == 3 {
            colors[3] = color
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension ColorsCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        switch indexPath.row {
        case 0...2:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierColorCell, for: indexPath) as! ColorCell
            cell.backgroundColor = colors[indexPath.row]
            (cell as! ColorCell).isCheck = indexPath.row == choosingIndexColor ? true : false
        case 3:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierGradientColorCell, for: indexPath) as! GradientCell
            
            if colors[indexPath.row] == nil {
                let gradientView = (cell as! GradientCell).gradientView
                gradientView?.colors = colorsForGradientView
                gradientView?.horizontalMode = gradientViewHorizontalMode
            } else {
                (cell as! GradientCell).gradientView?.removeFromSuperview()
                cell.backgroundColor = colors[indexPath.row]
            }
            (cell as! GradientCell).isCheck = indexPath.row == choosingIndexColor ? true : false
            
            // Add gesture recognizer
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            cell.addGestureRecognizer(longPressGesture)
            
        default: break
        }
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension ColorsCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 3 && colors[3] == nil { return }
        
        let oldIndexPath = IndexPath(item: choosingIndexColor, section: 0)
        guard oldIndexPath != indexPath else { return }
        choosingIndexColor = indexPath.item
        delegate?.didChangeColor(choosingColor ?? .white)
        
        collectionView.reloadItems(at: [oldIndexPath, indexPath])
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ColorsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = UIScreen.main.bounds.width / 5
        
        if width > 100 {
            width = 100
        }
        
        return CGSize(width: width, height: width)
    }
    
}

// MARK: - Navigation
extension ColorsCollectionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGradientPicker" {
            let colorPickerViewController = segue.destination as! ColorPickerViewController
            colorPickerViewController.colors = colorsForGradientView
            colorPickerViewController.horizontalMode = gradientViewHorizontalMode
            colorPickerViewController.choossedColor = colors[3]
            colorPickerViewController.delegate = self
        }
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        
    }
    
}

// MARK: - Gestures
extension ColorsCollectionViewController {
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
            self.performSegue(withIdentifier: "ShowGradientPicker", sender: nil)
            let oldIndexPath = IndexPath(item: choosingIndexColor, section: 0)
            let newIndexPath = IndexPath(item: 3, section: 0)
            guard oldIndexPath != newIndexPath else { return }
            choosingIndexColor = newIndexPath.item
            delegate?.didChangeColor(choosingColor ?? .white)
            
            collectionView.reloadItems(at: [oldIndexPath, newIndexPath])
        }
    }
    
}

// MARK: - ColorPickerViewControllerDelegate
extension ColorsCollectionViewController: ColorPickerViewControllerDelegate {
    
    func didChangeColor(_ color: UIColor) {
        
        colors[3] = color
        
        collectionView.reloadItems(at: [IndexPath(item: 3, section: 0)])
        delegate?.didChangeColor(color)
    }
    
}
