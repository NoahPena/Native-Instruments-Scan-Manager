//
//  ContentView.swift
//  Komplete Kontrol Speed Up
//
//  Created by Noah Peña on 9/27/24.
//

import SwiftUI

enum SupportedApplications: String
{
    case KompleteKontrol = "KompleteKontrol"
    case Maschine = "Maschine"
}

struct ContentView: View
{
    var body: some View
    {
        HSplitView
        {
            ItemView(content: "Komplete Kontrol", type: SupportedApplications.KompleteKontrol).padding()
            ItemView(content: "Maschine", type: SupportedApplications.Maschine).padding()
        }
    }
}

struct ItemView: View
{
    let content: String
    let type: SupportedApplications
    var body: some View
    {
        VStack
        {
            Spacer()
            HStack
            {
                Spacer()
                VStack
                {
                    Image(type.rawValue).resizable().frame(width: 100, height: 100)
                    Text(content).padding()
                }
                Spacer()
            }
            Spacer()
        }
    }
}

func signIn()
{
    print("Hello")
}

#Preview {
    ContentView()
}
