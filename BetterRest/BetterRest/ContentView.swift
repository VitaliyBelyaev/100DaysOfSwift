//
//  ContentView.swift
//  BetterRest
//
//  Created by Vitaliy on 24.02.2023.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    
    @State private var wakeUpDate = Date.now
    
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("When do want to wake up?")
                    .font(.headline)
                
                DatePicker("Enter a time", selection: $wakeUpDate,displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("How much coffee cups you drink in a day?")
                    .font(.headline)
                
                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                
                Spacer()
            }
            .padding()
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calcualte", action: calculateBedtime)
            }
            .alert(alertTitle, isPresented: $showAlert){
                Button("Ok") { }
            } message: {
                Text(alertMessage)
            }
        }
        
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpDate)
            let hourPartSeconds = (components.hour ?? 0) * 60 * 60
            let minutePartSeconds = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hourPartSeconds + minutePartSeconds), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUpDate - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime calculated"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, error occured while calculating your bedtime"
        }
        
        showAlert = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
