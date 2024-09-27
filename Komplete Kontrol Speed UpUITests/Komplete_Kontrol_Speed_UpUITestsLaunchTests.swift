//
//  Komplete_Kontrol_Speed_UpUITestsLaunchTests.swift
//  Komplete Kontrol Speed UpUITests
//
//  Created by Noah Peña on 9/27/24.
//

import XCTest

final class Komplete_Kontrol_Speed_UpUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
