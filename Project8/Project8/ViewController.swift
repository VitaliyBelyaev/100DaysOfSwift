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
    var submitButton: UIButton!
    var clearButton: UIButton!
    
    var letterButtons: [UIButton] = []
    var buttonsContainer: UIView!
    
    var activatedButtons: [UIButton] = []
    var solutions: [String] = []
    var viewableSolutions: [String] = []
    var score: Int = 0{
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var attempts: Int = 0
    
    var level = 1
    
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = UIColor.white
        
        scoreLabel = createScoreLabel()
        cluesLabel = createCluesLabel()
        answersLabel = createAnswersLabel()
        currentAnswer = createCurrentAnswerView()
        
        submitButton = createButton(title: "SUBMIT")
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        clearButton = createButton(title: "CLEAR")
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        buttonsContainer = createButtonsContainer()
        fillButtonsContainer()
        
        view.addSubview(scoreLabel)
        view.addSubview(cluesLabel)
        view.addSubview(answersLabel)
        view.addSubview(currentAnswer)
        view.addSubview(submitButton)
        view.addSubview(clearButton)
        view.addSubview(buttonsContainer)
        
        
        
        NSLayoutConstraint.activate(
            createScoreLabelConstraints() +
            createCluesLabelConstraints() +
            createAnswersLabelConstraints() +
            createCurrentAnswerViewConstraints() +
            createSubmitButtonConstraints() +
            createClearButtonConstraints() +
            createButtonsContainerConstraints()
        )
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    
    private func loadLevel() {
        var clueString = ""
        var letterBits = [String]()
        
        if let levelFileUrl = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileUrl) {
                var lines: [String] = levelContents.components(separatedBy: "\n")
                
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    viewableSolutions.append("\(solutionWord.count) letters")
                    
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
                
                
                cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
                answersLabel.text = viewableSolutions.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
                
                letterBits.shuffle()
                
                if letterBits.count == letterButtons.count {
                    for i in 0 ..< letterButtons.count {
                        letterButtons[i].setTitle(letterBits[i], for: .normal)
                    }
                }
                
                for button in letterButtons {
                    button.isHidden = false
                }
            }
        }
    }
    
    
    @objc
    private func lettetTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    @objc
    private func submitTapped(_ sender: UIButton) {
        attempts += 1
        guard let userAnswer = currentAnswer?.text else { return }
        
        if let matchingSolutionIndex = solutions.firstIndex(of: userAnswer){
            viewableSolutions[matchingSolutionIndex] = userAnswer
            answersLabel.text = viewableSolutions.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
            score += 1
            
            currentAnswer.text = ""
            activatedButtons.removeAll()
        } else {
            score -= 1
            clearTapped()
            
            
            if attempts % 7 != 0 {
                let ac = UIAlertController(title: "Wrong!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try again", style: .default))
                present(ac, animated: true)
            }
        }
        
        if attempts % 7 == 0 {
            let title: String
            if score % 7 == 0 {
                title = "Level ended, Well done!"
            } else {
                title = "Level ended"
            }
            
            let ac = UIAlertController(title: title, message: "Are you ready for the next level?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
            present(ac, animated: true)
        }
    }
    
    @objc
    private func clearTapped(_ sender: UIButton? = nil) {
        currentAnswer.text = ""
        
        for b in activatedButtons {
            b.isHidden = false
            
            activatedButtons.removeAll()
        }
    }
    
    @objc
    private func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        viewableSolutions.removeAll(keepingCapacity: true)
        loadLevel()
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
            it.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
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
            it.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
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
    
    private func createButtonsContainer() -> UIView {
        return UIView().apply { it in
            it.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func createButtonsContainerConstraints() -> [NSLayoutConstraint] {
        return [
            buttonsContainer.widthAnchor.constraint(equalToConstant: 750),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 320),
            buttonsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsContainer.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            buttonsContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ]
    }
    
    private func fillButtonsContainer() {
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system).apply { it in
                    it.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                    it.setTitle("WWW", for: .normal)
                    it.layer.borderWidth = 1
                    it.layer.borderColor = UIColor.gray.cgColor
                    it.frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                    it.addTarget(self, action: #selector(lettetTapped), for: .touchUpInside)
                }
                
                buttonsContainer.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
}



extension ScopeFunc {
    @inline(__always) func apply(block: (Self) -> ()) -> Self {
        block(self)
        return self
    }
    @inline(__always) func letIt<R>(block: (Self) -> R) -> R {
        return block(self)
    }
}

protocol ScopeFunc {}
extension NSObject: ScopeFunc {}

