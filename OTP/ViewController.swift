//
//  ViewController.swift
//  OTP
//
//  Created by Narzullaev Nurbek on 28/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    var otpCode = "1188"
    
    let hiddenTextField: UITextField = {
        let textfield = UITextField()
        textfield.layer.borderColor = UIColor.red.cgColor
        textfield.layer.borderWidth = 2
        textfield.keyboardType = .numberPad
        textfield.becomeFirstResponder()
        textfield.isHidden = true
        textfield.addTarget(self, action: #selector(checkOTP), for: .editingChanged)
        return textfield
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    let resendButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setTitleColor(.black, for: .normal)
        button.setTitle("If you have not received the code, we can resend it in 00:20 sec.", for: .normal)
        button.titleLabel?.numberOfLines = .max
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .setFont(forTextStyle: .body, weight: .medium)
        button.addTarget(self, action: #selector(resendOTP), for: .touchUpInside)
        return button
    }()
    
    var timer = Timer()
    var index = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        [hiddenTextField, stackView, resendButton].forEach { viewItem in
            view.addSubview(viewItem)
            viewItem.translatesAutoresizingMaskIntoConstraints = false
        }
        
        layout()
        
        hiddenTextField.delegate = self
        
        // Adding 4 our custom mini textfields into stackView
        for index in 1...4 {
            let field = CustomMiniTextField()
            if index == 1 { field.disabled() }
            field.tag = index
            self.stackView.addArrangedSubview(field)
        }
        
        // Start the timer
        startCountDown(second: 20)
        
    }
    
    
    private func layout() {
        NSLayoutConstraint.activate([
            hiddenTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            hiddenTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hiddenTextField.widthAnchor.constraint(equalToConstant: 200),
            
            stackView.topAnchor.constraint(equalTo: hiddenTextField.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            resendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resendButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            resendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            resendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
        ])
    }

}


extension ViewController {
    
    @objc func checkOTP() {
        if let otpText = self.hiddenTextField.text {
            if otpText.count == 4 {
                if otpText == otpCode {
                    let alert = UIAlertController(title: "Success", message: "You have been successfully verified!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(
                        title: "OK",
                        style: .default))
                    present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Incorrect digits", message: "You have entered incorrect digit codes, review the e-mail and try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(
                        title: "OK",
                        style: .default))
                    present(alert, animated: true)
                }
                
            }
        }
    }
    
    
    @objc
    func resendOTP() {
        self.resendButton.setTitleColor(.black, for: .normal)
        self.resendButton.setTitle("If you have not received the code, we can resend it in 00:20 sec.", for: .normal)
        self.startCountDown(second: 20)
    }
    
    
    func startCountDown(second: Int) {
        var timerSeconds = second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            timerSeconds = self.discounter(timerSeconds)
            let s = timerSeconds % 60
            let m = timerSeconds / 60
            
            if s < 10 {
                self.resendButton.setTitle("If you have not received the code, we can resend it in 0\(m):0\(s) sec.", for: .normal)
            } else {
                self.resendButton.setTitle("If you have not received the code, we can resend it in 0\(m):\(s) sec.", for: .normal)
            }
            
            if m == 0 && s == 0 {
                timer.invalidate()
                self.resendButton.setTitleColor(.systemBlue, for: .normal)
                self.resendButton.setTitle("Send the code again", for: .normal)
                self.resendButton.isUserInteractionEnabled = true
            }
        }
    }
    
    
    func discounter(_ n: Int) -> Int {
        var x = n
        x -= 1
        return x
    }
}


extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        var maxLength = 4
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        let isInteger = allowedCharacters.isSuperset(of: characterSet)
        
        if string.isEmpty { // if delete key is pressed
            if let field = stackView.subviews[self.index - 1] as? CustomMiniTextField {
                field.centerDot.isHidden = false
                field.text = ""
                self.index -= 1
            }
            
        } else if newString.count <= 4 {
            
            if index < 3 { // if field is not last one
                
                if let currentField = stackView.subviews[index] as? CustomMiniTextField, let nextField = stackView.subviews[index + 1] as? CustomMiniTextField {
                    currentField.centerDot.isHidden = true
                    self.index += 1
                    
                    if let text = currentField.text {
                        
                        if text.count == 1 {
                            nextField.text = string
                            //nextField.dot.isHidden = false
                        }
                        
                        if text.count == 0 { // when field is fillen
                            currentField.text = string
                        }
                    }
                }
                
            }
            
            
            if index == 3 {
                if let text = hiddenTextField.text {
                    if text.count == 3 {
                        if let nextField = stackView.subviews[index] as? CustomMiniTextField {
                            nextField.centerDot.isHidden = true
                            nextField.text = string
                            self.index += 1
                        }
                        
                    }
                }
            }
            
        }
        
        return newString.count <= maxLength && allowedCharacters.isSuperset(of: characterSet)
        
    }
}
