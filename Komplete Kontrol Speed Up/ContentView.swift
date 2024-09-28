//
//  ContentView.swift
//  Komplete Kontrol Speed Up
//
//  Created by Noah Peña on 9/27/24.
//

import SwiftUI



enum SupportedApplications: String, CaseIterable
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
            ForEach(SupportedApplications.allCases, id:\.self)
            {
                ItemView(content: $0.rawValue, type: $0, isEnabled: isApplicationInstalled(type: $0), toggle: isScanAppEnabled(type: $0))
            }
        }
    }
}

struct NotEnabledView: View
{
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 20).frame(width: 100, height: 100)
            Text("Disabled").colorInvert()
        }
    }
}

struct ItemView: View
{
    let content: String
    let type: SupportedApplications
    let isEnabled: Bool
    @State var toggle: Bool
    
    var toggleOnChange: Binding<Bool>
    {
        .init
        {
            return toggle
        }
        set:
        {
            newValue in
            processScanApp(type: type, enableScanApp: newValue)
            toggle = newValue
        }
    }
    
    var body: some View
    {
        ZStack
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
                        Text(content + " ScanApp").padding()
                        HStack
                        {
                            Text("Disabled")
                            Toggle(isOn: toggleOnChange)
                            {
                            }.toggleStyle(.switch).disabled(!isEnabled)
                            Text("Enabled")
                        }
                    }
                    Spacer()
                }
                Spacer()
            }.blur(radius: (isEnabled) ? 0 : 2)
            
            if !isEnabled
            {
                NotEnabledView()
            }
        }
    }
    
    
}

#Preview {
    ContentView()
}
