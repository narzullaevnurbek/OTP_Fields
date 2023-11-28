//
//  CustomTextField.swift
//  OTP
//
//  Created by Narzullaev Nurbek on 28/11/23.
//

import UIKit

class CustomMiniTextField: UITextField {
    
    let centerDot: UIImageView = {
        let centerDot = UIImageView()
        centerDot.image = UIImage(named: "dot")
        return centerDot
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.autocapitalizationType = .allCharacters
        self.textColor = .black
        self.font = .setFont(forTextStyle: .largeTitle, weight: .medium)
        self.textAlignment = .center
        self.keyboardType = .numberPad
        self.isUserInteractionEnabled = false
        
        [centerDot].forEach { viewItem in
            addSubview(viewItem)
            viewItem.translatesAutoresizingMaskIntoConstraints = false
        }
        
        layout()
        
    }
    
    
    private func layout() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 60),
            self.heightAnchor.constraint(equalToConstant: 50),
            
            centerDot.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            centerDot.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // There we should make the textfield prevent from being first responder, because we don't type the OTP digits directly to it.
    override var canBecomeFirstResponder: Bool {
        return false
    }
    
}
