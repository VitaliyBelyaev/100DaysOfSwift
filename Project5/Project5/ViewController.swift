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
        usedWords.append(answer)
        tableView.reloadData()
    }
}

