//
//  ColorPickerViewController.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 06.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

protocol ColorPickerViewControllerDelegate: class {
    func didChangeColor(_ color: UIColor)
}

class ColorPickerViewController: UIViewController {
    
    weak var delegate: ColorPickerViewControllerDelegate?
    
    var colors: [UIColor] = []
    var horizontalMode: Bool = false
    
    var choossedColor: UIColor? {
        didSet {
            updateCurrentColorBlock()
            delegate?.didChangeColor(choossedColor!)
        }
    }
    
    var currentPoint: CGPoint? {
        didSet { updatePositionScope() }
    }
    
    @IBOutlet weak var currentColorBlock: UIView! {
        didSet { setupCurrentColorBlock() }
    }
    @IBOutlet weak var currentColorStackView: UIStackView!
    @IBOutlet weak var currentColorView: UIView! {
        didSet { setupCurrentColorView() }
    }
    @IBOutlet weak var currentColorTextField: UITextField!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var gradientView: GradientView! {
        didSet { setupGradientView() }
    }
    @IBOutlet weak var scopeImageView: UIImageView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentPoint == nil {
            currentPoint = scopeImageView.center
        }
        
        if choossedColor == nil {
            choossedColor = gradientView.pixelColor(atLocation: currentPoint!)
        }
        
        let alpha = choossedColor?.cgColor.components?[3]
        updateBrightnessSlider(Float(alpha!))
        
        updateCurrentColorBlock()
        updateBrightnessGradietView(CGFloat(brightnessSlider.value))
        
        // Add gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        gradientView.addGestureRecognizer(panGesture)
        gradientView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func actionBrightnessChange(_ sender: UISlider) {
        updateBrightnessGradietView(CGFloat(sender.value))
        choossedColor = gradientView.pixelColor(atLocation: currentPoint!)
    }
    
    // MARK: - Gestures
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        //guard let sender = sender else { return }
        if case .changed = sender.state {
            currentPoint = sender.location(in: gradientView)
            choossedColor = gradientView.pixelColor(atLocation: currentPoint!)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        //guard let sender = sender else { return }
        if case .ended = sender.state {
            currentPoint = sender.location(in: gradientView)
            choossedColor = gradientView.pixelColor(atLocation: currentPoint!)
        }
    }
    
    // MARK: - Private methods
    private func setupCurrentColorBlock() {
        currentColorBlock.layer.borderWidth = 1.0
        currentColorBlock.layer.borderColor = UIColor.black.cgColor
        currentColorBlock.layer.cornerRadius = 10.0
    }

    private func setupCurrentColorView() {
        currentColorView.layer.masksToBounds = false
        currentColorView.layer.shadowColor = UIColor.black.cgColor
        currentColorView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        currentColorView.layer.shadowOpacity = 1.0
        currentColorView.layer.shadowRadius = 0.0
    }
    
    private func setupGradientView() {
        gradientView.colors = colors
        gradientView.horizontalMode = true
        gradientView.layer.borderWidth = 1.0
        gradientView.layer.borderColor = UIColor.black.cgColor
    }
    
    private func updateBrightnessSlider(_ alphaComponent: Float) {
        brightnessSlider.setValue(alphaComponent, animated: true)
    }
    private func updateBrightnessGradietView(_ alphaComponent: CGFloat) {
        gradientView.colors = gradientView.colors.map { $0.withAlphaComponent(alphaComponent) }
    }
    
    private func updateCurrentColorBlock() {
        currentColorView?.backgroundColor = choossedColor
        currentColorTextField?.text = choossedColor?.hexString
    }
    
    private func updatePositionScope() {
        scopeImageView.center = currentPoint!
    }
    
}

extension ColorPickerViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            if updatedText.count == 7 {
                let rgb = updatedText.hexInt
                let color = UIColor(rgba: Int(rgb)).withAlphaComponent(CGFloat(brightnessSlider!.value))
                currentColorView.backgroundColor = color
            }
            
        }
        return true
    }
    
}
