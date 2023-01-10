//
//  ViewController.swift
//  Project5
//
//  Created by Vitaliy on 09.01.2023.
//

import UIKit

class ViewController: UITableViewController {

    var allWords: [String] = []
    var usedWords: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTapped))
        
        allWords = loadStartWords() ?? ["silkworm"]
        
        startGame()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    private func loadStartWords() -> [String]? {
        guard let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") else { return nil }
        
        guard let startWords = try? String(contentsOf: startWordsUrl) else { return nil }
        
        
        return startWords.components(separatedBy: "\n")
    }
    
    private func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc private func onAddTapped() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        let submitAction  = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            
            guard let answer = ac?.textFields?[0].text else { return }
            
            self?.sumbit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    private func sumbit(_ answer: String) {
        
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        let validationResult = validateWord(lowerAnswer)
        
        switch validationResult {
        case .valid:
            usedWords.insert(lowerAnswer, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            return
        case .notReal:
            errorTitle = "Word not recognized"
            errorMessage = "You can't just make them up, you know!"
        case .notOrigin:
            errorTitle = "Word is already used"
            errorMessage = "Be more original!"
        case .notPossible:
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title!.lowercased())"
            
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    private func validateWord(_ word: String) -> ValidationResult {
        if !isReal(word){
            return ValidationResult.notReal
        }
        if !isPossible(word){
            return ValidationResult.notPossible
        }
        if !isOrigin(word){
            return ValidationResult.notOrigin
        }
        return ValidationResult.valid
    }
    
    private func isPossible(_ word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    private func isOrigin(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    private func isReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
}

private enum ValidationResult {
    case valid
    case notReal
    case notPossible
    case notOrigin
}

