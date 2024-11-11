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
let CHANGED_SCAN_APP3_NAME: String = "ScanApp3.app.old"
let SCAN_APP_NAME: String = "ScanApp.app"
let CHANGED_SCAN_APP_NAME: String = "ScanApp.app.old"

var MASCHINE_SCAN_APP_NAME: String = SCAN_APP3_NAME
var KOMPLETE_KONTROL_SCAN_APP_NAME: String = SCAN_APP3_NAME

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
        return KOMPLETE_KONTROL_SCAN_APP_NAME
            
        case SupportedApplications.Maschine:
        return MASCHINE_SCAN_APP_NAME
    }
}

func getChangedScanAppFileName(name: String) -> String
{
    if name == SCAN_APP3_NAME
    {
        return CHANGED_SCAN_APP3_NAME
    }
    else
    {
        return CHANGED_SCAN_APP_NAME
    }
}


func isScanAppEnabled(type: SupportedApplications) -> Bool
{
    
    let scanAppDirectory: String = getScanAppDirectory(type: type)
    let scanAppName: String = getScanAppFileName(type: type)
    let changedScanAppName: String = getChangedScanAppFileName(name: scanAppName)
    
    // We know that the Application exists, so we can safely look for the ScanApp Files
    // The possible outcomes are as followed:
    //
    // ScanApp file exists but ScanApp.old does not = Currently Enabled
    // ScanApp file does not exist and ScanApp.old exists = Currently Disabled
    // ScanApp file exists and ScanApp.old exists = Application has been Recently Updated = Currently Enabled
    
    let scanAppState = FileManager.default.fileExists(atPath: scanAppDirectory + scanAppName)
    let changedScanAppState = FileManager.default.fileExists(atPath: scanAppDirectory + changedScanAppName)
    
    if (scanAppState && changedScanAppState)
    {
        // New Version was recently installed so we'll remove the old scan app and return false
        try! FileManager.default.removeItem(at: URL(fileURLWithPath: String(scanAppDirectory + changedScanAppName)))
        return true
    }
    
    if (scanAppState && !changedScanAppState)
    {
        // Just the ScanApp exists so we'll return true
        return true
    }
    
    return false
    
}

func setScanAppName(type: SupportedApplications, name: String)
{
    switch type
    {
        case SupportedApplications.KompleteKontrol:
            KOMPLETE_KONTROL_SCAN_APP_NAME = name
            break
            
        case SupportedApplications.Maschine:
            MASCHINE_SCAN_APP_NAME = name
            break
    }
}

func isApplicationInstalled(type: SupportedApplications) -> Bool
{
    
    let scanAppDirectory: String = getScanAppDirectory(type: type)
    var result: Bool = true
    
    // Old Versions of Komplete Kontrol and Maschine use the regular ScanApp
    // while newer versions use ScanApp3, so we'll check for which one we have
    
    if FileManager.default.fileExists(atPath: String(scanAppDirectory + SCAN_APP3_NAME))
    {
        setScanAppName(type: type, name: SCAN_APP3_NAME)
    }
    else if FileManager.default.fileExists(atPath: String(scanAppDirectory + SCAN_APP_NAME))
    {
        setScanAppName(type: type, name: SCAN_APP_NAME)
    }
    else if FileManager.default.fileExists(atPath: String(scanAppDirectory + CHANGED_SCAN_APP3_NAME))
    {
        setScanAppName(type: type, name: SCAN_APP3_NAME)
    }
    else if FileManager.default.fileExists(atPath: String(scanAppDirectory + CHANGED_SCAN_APP_NAME))
    {
        setScanAppName(type: type, name: SCAN_APP_NAME)
    }
    else
    {
        // Couldn't find it
        result = false
    }
    
    return result
}

func processScanApp(type: SupportedApplications, enableScanApp: Bool)
{
    let scanAppDirectory: String = getScanAppDirectory(type: type)
    let scanAppName: String = getScanAppFileName(type: type)
    let changedScanAppName: String = getChangedScanAppFileName(name: scanAppName)
    let scanAppURL: URL = URL(fileURLWithPath: String(scanAppDirectory + scanAppName))
    let changedScanAppURL: URL = URL(fileURLWithPath: String(scanAppDirectory + changedScanAppName))
    
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

