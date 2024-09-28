//
//  NIFileHandling.swift
//  Komplete Kontrol Speed Up
//
//  Created by Noah Peña on 9/27/24.
//

import Foundation

let DEFAULT_KOMPLETE_KONTROL_SCAN_APP_DIRECTORY: String = "/Library/Application Support/Native Instruments/Komplete Kontrol/"
let DEFAULT_MASCHINE_SCAN_APP_DIRECTORY: String = "/Library/Application Support/Native Instruments/Maschine 2/"
let SCAN_APP3_NAME: String = "ScanApp3.app"
let CHANGED_SCAN_APP_NAME: String = "ScanApp3.app.old"
let SCAN_APP_NAME: String = "ScanApp.app"


func getScanAppDirectory(type: SupportedApplications) -> String
{
    switch type
    {
        case SupportedApplications.KompleteKontrol:
            return DEFAULT_KOMPLETE_KONTROL_SCAN_APP_DIRECTORY
            
        case SupportedApplications.Maschine:
            return DEFAULT_MASCHINE_SCAN_APP_DIRECTORY
    }
}

func getScanAppFileName(type: SupportedApplications) -> String
{
    switch type
    {
        case SupportedApplications.KompleteKontrol:
            return SCAN_APP3_NAME
            
        case SupportedApplications.Maschine:
            return SCAN_APP_NAME
    }
}


func isScanAppEnabled(type: SupportedApplications) -> Bool
{
    
    let scanAppDirectory: String = getScanAppDirectory(type: type)
    let scanAppName: String = getScanAppFileName(type: type)
    
    // We know that the Application exists, so we can safely look for the ScanApp Files
    // The possible outcomes are as followed:
    //
    // ScanApp file exists but ScanApp.old does not = Currently Enabled
    // ScanApp file does not exist and ScanApp.old exists = Currently Disabled
    // ScanApp file exists and ScanApp.old exists = Application has been Recently Updated = Currently Enabled
    
    let scanAppState = FileManager.default.fileExists(atPath: scanAppDirectory + scanAppName)
    let changedScanAppState = FileManager.default.fileExists(atPath: scanAppDirectory + CHANGED_SCAN_APP_NAME)
    
    if (scanAppState && changedScanAppState)
    {
        // New Version was recently installed so we'll remove the old scan app and return false
        try! FileManager.default.removeItem(at: URL(fileURLWithPath: String(scanAppDirectory + CHANGED_SCAN_APP_NAME)))
        return true
    }
    
    if (scanAppState && !changedScanAppState)
    {
        // Just the ScanApp exists so we'll return true
        return true
    }
    
    return false
    
}

func isApplicationInstalled(type: SupportedApplications) -> Bool
{
    var returnValue: Bool = false
    
    switch type
    {
    case SupportedApplications.KompleteKontrol:
        returnValue = FileManager.default.fileExists(atPath: String(DEFAULT_KOMPLETE_KONTROL_SCAN_APP_DIRECTORY + SCAN_APP_NAME)) || FileManager.default.fileExists(atPath: String(DEFAULT_KOMPLETE_KONTROL_SCAN_APP_DIRECTORY + CHANGED_SCAN_APP_NAME))
        break
        
    case SupportedApplications.Maschine:
        returnValue = FileManager.default.fileExists(atPath: DEFAULT_MASCHINE_SCAN_APP_DIRECTORY + SCAN_APP_NAME) || FileManager.default.fileExists(atPath: String(DEFAULT_MASCHINE_SCAN_APP_DIRECTORY + CHANGED_SCAN_APP_NAME))
        break
    }
    
    return returnValue
}

func processScanApp(type: SupportedApplications, enableScanApp: Bool)
{
    let scanAppDirectory: String = getScanAppDirectory(type: type)
    let scanAppName: String = getScanAppFileName(type: type)
    let scanAppURL: URL = URL(fileURLWithPath: String(scanAppDirectory + scanAppName))
    let changedScanAppURL: URL = URL(fileURLWithPath: String(scanAppDirectory + CHANGED_SCAN_APP_NAME))
    
    if enableScanApp
    {
        // Re-Enabled Scan App
        // So we need to move the ScanApp3.app.old to being ScanApp3.app
        try! FileManager.default.moveItem(at: changedScanAppURL, to: scanAppURL)
    }
    else
    {
        // Disable Scan App
        // So we need to move the ScanApp3.app to being ScanApp3.app.old
        do
        {
            try FileManager.default.moveItem(at: scanAppURL, to: changedScanAppURL)
            
        } catch {
            print(error)
        }
    }
}

