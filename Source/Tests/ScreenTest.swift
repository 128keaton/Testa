//
//  ScreenTestViewController.swift
//  Toot
//
//  Created by Keaton Burleson on 8/28/17.
//  Copyright © 2017 er2. All rights reserved.
//

import Foundation
import UIKit

public class ScreenTest: Test {

    override init(inViewController: UIViewController) {
        super.init(inViewController: inViewController)
        self.type = .Screen
    }

    override public func setupView() {
        self.parentController?.view.backgroundColor = UIColor.black
        instructionLabel?.textColor = UIColor.white

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tapGesture.numberOfTapsRequired = 1
        self.parentController?.view.addGestureRecognizer(tapGesture)
        super.setupView()
    }

    override func startTests() {
        let alertController = UIAlertController(title: "Pay Attention", message: "Please check for blemishes and discoloration", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (alert) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okayAction)
        self.parentController?.present(alertController, animated: true, completion: nil)
    }


    /**
     MARK: Test Specific Functions
     **/

    func displayGradeController() {
        let alertController = UIAlertController(title: "Grade", message: "How many screen defects?", preferredStyle: .actionSheet)
        let minimalAction = UIAlertAction(title: "One or less", style: .default) { (alert) in
            self.setScreenGrade(grade: .perfect)
        }
        let fairAction = UIAlertAction(title: "Two", style: .default) { (alert) in
            self.setScreenGrade(grade: .fair)
        }
        let poorAction = UIAlertAction(title: "Three", style: .default) { (alert) in
            self.setScreenGrade(grade: .poor)
        }

        alertController.addAction(minimalAction)
        alertController.addAction(fairAction)
        alertController.addAction(poorAction)

        self.parentController?.present(alertController, animated: true, completion: nil)
    }

    func setScreenGrade(grade: ScreenGrade) {
        guard let data = self.testData
            else {
                return
        }
        data.screenGrade = grade
        isScreenCracked()
    }

    func isScreenCracked() {
        guard let data = self.testData
            else {
                return
        }
        self.displayPrompt(body: "Is the screen cracked?") {
            if self.successful {
                data.screenCracked = true
            } else {
                data.screenCracked = false
            }
            self.testSuccess()
        }

    }


    @objc func tapAction() {
        switch self.parentController?.view.backgroundColor! {
        case UIColor.black?:
            self.parentController?.view.backgroundColor = UIColor.white
            break
        case UIColor.white?:
            self.parentController?.view.backgroundColor = UIColor.red
            break
        case UIColor.red?:
            self.parentController?.view.backgroundColor = UIColor.blue
            break
        case UIColor.blue?:
            self.parentController?.view.backgroundColor = UIColor.green
            break
        default:
            displayGradeController()
        }
        instructionLabel?.textColor = getComplimentaryColorFor(color: (self.parentController?.view.backgroundColor!)!)
    }

    func getComplimentaryColorFor(color: UIColor) -> UIColor {
        let ciColor = CIColor(color: color)

        // get the current values and make the difference from white:
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue

        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
    }

}


