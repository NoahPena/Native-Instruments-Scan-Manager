//
//  ContentView.swift
//  Komplete Kontrol Speed Up
//
//  Created by Noah Peña on 9/27/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button(action: signIn)
            {
                Text("Test")
            }
        }
        .padding()
    }
}

func signIn()
{
    print("Hello")
}

#Preview {
    ContentView()
}
