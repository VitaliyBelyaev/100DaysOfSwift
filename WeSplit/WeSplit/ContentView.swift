//
//  ContentView.swift
//  WeSplit
//
//  Created by Vitaliy on 03.02.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, iOS!")
                .foregroundColor(Color.red)
                .font(Font.largeTitle)
                .padding(EdgeInsets.init(top: 24, leading: 0, bottom: 0, trailing: 0))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
