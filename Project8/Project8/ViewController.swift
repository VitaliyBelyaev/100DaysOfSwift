//
//  ViewController.swift
//  Project8
//
//  Created by Vitaliy on 16.01.2023.
//

import UIKit

class ViewController: UIViewController {

    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons: [UIButton] = []
    var submitButton: UIButton!
    var clearButton: UIButton!
    
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = UIColor.white
        
        scoreLabel = createScoreLabel()
        cluesLabel = createCluesLabel()
        answersLabel = createAnswersLabel()
        currentAnswer = createCurrentAnswerView()
        submitButton = createButton(title: "SUBMIT")
        clearButton = createButton(title: "CLEAR")
        
        view.addSubview(scoreLabel)
        view.addSubview(cluesLabel)
        view.addSubview(answersLabel)
        view.addSubview(currentAnswer)
        view.addSubview(submitButton)
        view.addSubview(clearButton)
    
        NSLayoutConstraint.activate(
            createScoreLabelConstraints() +
            createCluesLabelConstraints() +
            createAnswersLabelConstraints() +
            createCurrentAnswerViewConstraints() +
            createSubmitButtonConstraints() +
            createClearButtonConstraints()
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    private func createScoreLabel() -> UILabel {
        return UILabel().apply { it in
            it.translatesAutoresizingMaskIntoConstraints = false
            it.textAlignment = .right
            it.text = "Score: 0"
        }
    }
    
    private func createScoreLabelConstraints() -> [NSLayoutConstraint] {
        return [
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ]
    }
    
    private func createCluesLabel() -> UILabel {
        return UILabel().apply { it in
            it.translatesAutoresizingMaskIntoConstraints = false
            it.font = UIFont.systemFont(ofSize: 24)
            it.text = "CLUES"
            it.numberOfLines = 0
            it.backgroundColor = .red
        }
    }
    
    private func createCluesLabelConstraints() -> [NSLayoutConstraint] {
        return [
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: 100),
        ]
    }
    
    private func createAnswersLabel() -> UILabel {
        return UILabel().apply { it in
            it.translatesAutoresizingMaskIntoConstraints = false
            it.font = UIFont.systemFont(ofSize: 24)
            it.textAlignment = .right
            it.text = "ANSWERS"
            it.numberOfLines = 0
            it.backgroundColor = .green
        }
    }
    
    private func createAnswersLabelConstraints() -> [NSLayoutConstraint] {
        return [
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
        ]
    }
    
    private func createCurrentAnswerView() -> UITextField {
        return UITextField().apply { it in
            it.translatesAutoresizingMaskIntoConstraints = false
            it.font = UIFont.systemFont(ofSize: 44)
            it.placeholder = "Tap letters to guess"
            it.textAlignment = .center
            it.isUserInteractionEnabled = false
        }
    }
    
    private func createCurrentAnswerViewConstraints() -> [NSLayoutConstraint] {
        return [
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20)
        ]
    }
    
    private func createButton(title: String) -> UIButton {
        return UIButton(type: .system).apply { it in
            it.translatesAutoresizingMaskIntoConstraints = false
            it.setTitle(title, for: .normal)
        }
    }
        
    private func createSubmitButtonConstraints() -> [NSLayoutConstraint] {
        return [
            submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ]
    }
    
    private func createClearButtonConstraints() -> [NSLayoutConstraint] {
        return [
            clearButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clearButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor)
        ]
    }
    
}

struct ViewWithConstraints{
    let view: UIView
    let constraints: [NSLayoutConstraint]
}

protocol ScopeFunc {}
extension ScopeFunc {
    @inline(__always) func apply(block: (Self) -> ()) -> Self {
        block(self)
        return self
    }
    @inline(__always) func letIt<R>(block: (Self) -> R) -> R {
        return block(self)
    }
}

extension NSObject: ScopeFunc {}

