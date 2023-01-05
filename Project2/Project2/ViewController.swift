//
//  ViewController.swift
//  Project2
//
//  Created by Vitaliy on 02.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    @IBOutlet var buttonsWidthConstraint: NSLayoutConstraint!
    

    private lazy var buttons: [UIButton] = [button1, button2, button3]
    private let buttonsBorderWidth: CGFloat = 1.5
    
    private var countries: [String] = [
        "estonia",
        "us",
        "france",
        "russia",
        "germany",
        "ireland",
        "italy",
        "monaco",
        "nigeria",
        "poland",
        "spain",
        "uk"
    ]
    private var score: Int = 0
    private var correctAnswerIndex: Int = 0
    private var questionsCount: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
        
        adjustButtonsWidthForIpadIfNeeded()
        setupButtonsBorders()
        askQuiestion()
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        var alertTitle: String
        var message: String
        
        if sender.tag == correctAnswerIndex {
            score += 1
            alertTitle = "Correct"
            message = "Your score is \(score)"
        } else {
            score -= 1
            alertTitle = "Wrong"
            message = "You choose \(getPrettyCountryTitle(countries[sender.tag]))\nYour score is \(score)"
        }
        
        updateTitle()
        
        showAlert(title: alertTitle, message: message, buttonText: "Continue", action: askQuiestion)
    }
    
    
    private func showAlert(title: String,
                           message: String,
                           buttonText: String,
                           action: ((UIAlertAction?) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: buttonText, style: .default, handler: action))
        
        present(alertController, animated: true)
    }
    
    private func adjustButtonsWidthForIpadIfNeeded() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            buttonsWidthConstraint.constant = 400
            button1.layoutIfNeeded()
        }
    }

    private func setupButtonsBorders() {
        for button in buttons {
            button.layer.borderWidth = buttonsBorderWidth
            button.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    private func askQuiestion(action: UIAlertAction? = nil) {
        countries.shuffle()
        correctAnswerIndex = Int.random(in: 0...2)
        
        
        for (i, button) in zip(buttons.indices, buttons) {
            button.setBackgroundImage(UIImage(named: countries[i]), for: .normal)
        }
        
        updateTitle()
        
        if questionsCount == 10 {
            showAlert(title: "You finished the game", message: "Your final score is \(score)", buttonText: "Start new game", action: askQuiestion)
            score = 0
            questionsCount = 0
            return
        }
        questionsCount += 1
    }
    
    @objc private func showScore() {
        showAlert(title: "", message: "Your score is \(score)", buttonText: "Continue")
    }
    
    private func updateTitle() {
        title = "\(getPrettyCountryTitle(countries[correctAnswerIndex])) | Score: \(score)"
    }
    
    private func getPrettyCountryTitle(_ originCountryTitle: String) -> String {
        if (originCountryTitle == "us" || originCountryTitle == "uk") {
            return originCountryTitle.uppercased()
        } else {
            return originCountryTitle.capitalized
        }
    }
}

