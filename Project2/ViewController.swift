//
//  ViewController.swift
//  Project2
//
//  Created by Vitaliy on 02.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIImageView!
    @IBOutlet var button2: UIImageView!
    @IBOutlet var button3: UIImageView!
    
    @IBOutlet var button1WidthConstraint: NSLayoutConstraint!
    
    private lazy var buttons: [UIImageView] = [button1, button2, button3]
    
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
    private let buttonsBorderWidth: CGFloat = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustButtonsWidthForIpadIfNeeded()
        setupButtonsBorders()
        askQuiestion()
    }
    
    private func adjustButtonsWidthForIpadIfNeeded() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            button1WidthConstraint.constant = 400
            button1.layoutIfNeeded()
        }
    }

    private func setupButtonsBorders() {
        for button in buttons {
            button.layer.borderWidth = buttonsBorderWidth
            button.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    private func askQuiestion() {
        button1.image = UIImage(named: countries[0])
        button2.image = UIImage(named: countries[1])
        button3.image = UIImage(named: countries[2])
    }

}

