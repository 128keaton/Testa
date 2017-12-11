//
//  iOSTestController.swift
//  Testa
//
//  Created by Keaton Burleson on 12/1/17.
//  Copyright © 2017 er2. All rights reserved.
//

import Foundation
import UIKit

public class Test: NSObject {
    var testData: TestData? = nil
    var debugMode: Bool = false
    var skip: Bool = false
    var successful: Bool = true
    var currentAlert: UIAlertController? = nil
    var parentController: UIViewController? = nil
    public var type: TestType = .Ambiguous

    fileprivate var firstCompletionTime = true

    weak var delegate: TestDelegate?

    var instructionLabel: UILabel?
    var previewView: UIView?

    init(inViewController: UIViewController) {
        self.parentController = inViewController
    }

    /**
     MARK: Helpers
     **/

    func displayPrompt(body: String, title: String = "Question", yesText: String = "Yes", noText: String = "No", brokenState: Bool = false, completion: @escaping () -> Void) {
        let resultController = UIAlertController(title: title, message: body, preferredStyle: .alert)
        self.currentAlert = resultController
        if brokenState == false {
            let yesAction = UIAlertAction(title: yesText, style: .default) { (action) in
                resultController.dismiss(animated: true, completion: nil)
                self.successful = true
                completion()

            }
            let noAction = UIAlertAction(title: noText, style: .destructive) { (action) in
                resultController.dismiss(animated: true, completion: nil)
                self.successful = false
                completion()
            }
            resultController.addAction(yesAction)
            resultController.addAction(noAction)
        } else {
            let brokenAction = UIAlertAction(title: "It is not working", style: .destructive) { (action) in
                resultController.dismiss(animated: true, completion: nil)
                self.successful = false
                completion()
            }
            resultController.addAction(brokenAction)
        }

        if self.debugMode == true {
            let skipAction = UIAlertAction(title: "Skip", style: .default, handler: { (action) in
                resultController.dismiss(animated: true, completion: nil)
                self.skip = true
                completion()
            })
            resultController.addAction(skipAction)
        }


        self.parentController?.present(resultController, animated: true, completion: nil)
    }

    public func setupView() {
        print("Setting up \(self.type)")
    }

    public func dismissCurrentAlert() {
        if self.currentAlert != nil {
            self.currentAlert?.dismiss(animated: true, completion: nil)
        }
    }

    func testSuccess() {
        guard firstCompletionTime else {
            return
        }
        self.dismissCurrentAlert()
        self.delegate?.testCompleted(test: self.type, data: self.testData!, failed: false)

        firstCompletionTime = false
    }

    func testFail() {
        guard firstCompletionTime else {
            return
        }

        self.dismissCurrentAlert()
        self.delegate?.testCompleted(test: self.type, data: self.testData!, failed: true)

        firstCompletionTime = false
    }

    func startTests() {
        fatalError("Subclasses need to implement the `startTests()` method.")
    }

    func setInstructionalText(message: String) {
        if self.instructionLabel != nil {
            self.instructionLabel?.text = message
        }
    }
}
protocol TestDelegate: NSObjectProtocol {
    func testCompleted(test: TestType, data: TestData, failed: Bool)
}
