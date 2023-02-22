//
//  ContentView.swift
//  GuessFlagSU
//
//  Created by Vitaliy on 05.02.2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var inProgressShowingScore = false
    
    @State private var inProgressScoreTitle = ""
    
    @State private var gameOverShowingAlert = false
    
    @State private var gameOverAlertTitle = ""
    
    @State private var countries: [String] = [
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
    ].shuffled()
    
    @State private var score: Int = 0
    @State private var correctAnswerIndex: Int = Int.random(in: 0...2)
    private let gameQuestionsCount = 8
    @State private var questionsCount: Int = 1
    
    var body: some View {
        ZStack {
            
            let colors = [Color(red: 0.1, green: 0.2, blue: 0.45), Color(red: 0.76, green: 0.15, blue: 0.26)]
            
            LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)
    
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("Tap the flag off")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.secondary)
                        
                        Text(getPrettyCountryTitle(countries[correctAnswerIndex]))
                            .font(.title)
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                            
                            
                        }
                        .cornerRadius(16)
                        .shadow(radius: 8)
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                
                Text("Question: \(questionsCount) of \(gameQuestionsCount)")
                    .foregroundColor(.white)
                    .font(.body.bold())
                
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(inProgressScoreTitle, isPresented: $inProgressShowingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert(gameOverAlertTitle, isPresented: $gameOverShowingAlert) {
            Button("Restart game", action: restartGame)
        } message: {
            Text("Your final score is \(score) of \(gameQuestionsCount)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if (questionsCount == gameQuestionsCount) {
            if number == correctAnswerIndex {
                gameOverAlertTitle = "Correct, game is over!"
                score += 1
            } else {
                let tappedFlagName = getPrettyCountryTitle(countries[number])
                gameOverAlertTitle = "Wrong, that’s the flag of \(tappedFlagName), game is over!"
                if (score > 0) {
                    score -= 1
                }
            }
            
            gameOverShowingAlert = true
            
        } else {
            if number == correctAnswerIndex {
                inProgressScoreTitle = "Correct"
                score += 1
            } else {
                let tappedFlagName = getPrettyCountryTitle(countries[number])
                inProgressScoreTitle = "Wrong, that’s the flag of \(tappedFlagName)"
                if (score > 0) {
                    score -= 1
                }
            }
            
            inProgressShowingScore = true
        }
        
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswerIndex = Int.random(in: 0...2)
        questionsCount += 1
    }
    
    func restartGame() {
        score = 0
        questionsCount = 0
        askQuestion()
    }
    
    private func getPrettyCountryTitle(_ originCountryTitle: String) -> String {
        if (originCountryTitle == "us" || originCountryTitle == "uk") {
            return originCountryTitle.uppercased()
        } else {
            return originCountryTitle.capitalized
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
