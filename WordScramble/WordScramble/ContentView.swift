//
//  ContentView.swift
//  WordScramble
//
//  Created by Vitaliy on 26.02.2023.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    @State private var usedWords: [String] = []
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    @State private var startWords: [String] = []
    
    @State private var score = 0
    
    
    var body: some View {
        NavigationView {
            List {
                
                HStack {
                    Text(rootWord)
                        .font(.title)
                    Spacer()
                    Text("Score: \(score)")
                }
                
                TextField("Enter your word", text: $newWord)
                    .textInputAutocapitalization(.never)
                
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        
                    }
                }
            }
            .toolbar {
                Button("Restart game") {
                    restartGame()
                }
            }
            .onSubmit(addNewWord)
            .onAppear(perform: {
                loadStartWords()
                restartGame()
            })
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
                
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isOrigin(answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        score = score + getWordScore(word: answer)
        
        newWord = ""
    }
    
    func restartGame() {
        rootWord = startWords.randomElement() ?? "silkworm"
        usedWords.removeAll(keepingCapacity: true)
        score = 0
    }
    
    func loadStartWords() {
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String.init(contentsOf: startWordsUrl) {
                self.startWords = startWords.components(separatedBy: "\n")
                return
            }
        }
        
        fatalError("Can not load start words from file")
    }
    
    private func getWordScore(word: String) -> Int {
        let lettersScore: Double = Double(word.count) * 0.5
        
        return 1 + Int(lettersScore.rounded())
    }
    
    private func isPossible(_ word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        
        if word == tempWord {
            return false
        }
        
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
        if word.count < 3 {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    private func wordError(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
