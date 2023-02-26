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
    
    @State private var wakeUpDate = defaultWakeTime
    
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
        
    var idealBedtime: Date {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpDate)
            let hourPartSeconds = (components.hour ?? 0) * 60 * 60
            let minutePartSeconds = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hourPartSeconds + minutePartSeconds), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            return wakeUpDate - prediction.actualSleep
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, error occured while calculating your bedtime"
            showAlert = true
            return Date.now
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    
    var body: some View {
        
        NavigationView {
            
            
            Form {
                Section {
                    HStack {
                        Text("When do want to wake up?")
                        
                        Spacer()
                        DatePicker("Enter a time", selection: $wakeUpDate,displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                
                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                }
                
                Section {
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) {
                            Text("\($0)")
                        }
                    }
                } header: {
                    Text("How much coffee cups you drink in a day?")
                }
                
                Section {
                    Text("\(idealBedtime.formatted(date: .omitted, time: .shortened))")
                        .bold()
                } header: {
                    Text("Your ideal bedtime is")
                        .font(.headline)
                }
            }
            
            
            .navigationTitle("BetterRest")
            .alert(alertTitle, isPresented: $showAlert){
                Button("Ok") { }
            } message: {
                Text(alertMessage)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
