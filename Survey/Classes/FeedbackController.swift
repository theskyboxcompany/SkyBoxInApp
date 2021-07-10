//
//  FeedbackController.swift
//  Feedback
//
//  Created by Rohan Moradiya on 16/06/21.
//

import Foundation
import UIKit

public class FeedbackController: NSObject {
    
//    static let shared = FeedbackController()
    public class func configure(_ bundleID: String) {
        
    }
    
    public func presentFeedbackPopup(_ fromController: UIViewController) {
        
//        let configuration = RatingConfiguration(ratingStyle: .OneToTen, primaryTitle1: "Title 1", primaryTitle2: "Title 2", secondaryTitle: "Secondary title 2", primaryButtonTitle: "Submit", secondaryButtonTitle: "Secondary butiton", doneButtonTitle: "Done buttion")
        
//        let configuration = RatingConfiguration(ratingStyle: .OneToFive, primaryTitle1: "Taking photos", primaryTitle2: nil, secondaryTitle: "Pictures/files taken/scanned are lear and oriented correctly", primaryButtonTitle: "Submit", secondaryButtonTitle: nil, doneButtonTitle: nil)
        
//        let configuration = RatingConfiguration(ratingStyle: .Stars, primaryTitle1: nil, primaryTitle2: "How was the connection?", secondaryTitle: nil, primaryButtonTitle: "Submit", secondaryButtonTitle: nil, doneButtonTitle: nil)
        
//        let configuration = RatingConfiguration(ratingStyle: .Emoji, primaryTitle1: "How was the connection?", primaryTitle2: nil, secondaryTitle: "It would be great if you could leave a good review for us on the App Store. It’d help us improve our product for you!", primaryButtonTitle: "Submit", secondaryButtonTitle: "I'll do it later", doneButtonTitle: nil)
        
        let configuration = RatingConfiguration(ratingStyle: .MCQ, primaryTitle1: "How was the connection?", primaryTitle2: nil, secondaryTitle: "It would be great if you could leave a good review for us on the App Store. It’d help us improve our product for you! this is test more text", primaryButtonTitle: "Submit", secondaryButtonTitle: "I'll do it later", doneButtonTitle: nil)
        
//        let configuration = RatingConfiguration(ratingStyle: .ThankYou, primaryTitle1: "Thank you for feedback", primaryTitle2: nil, secondaryTitle: "It would be great if you could leave a good review for us on the App Store. It’d help us improve our product for you!", primaryButtonTitle: nil, secondaryButtonTitle: nil, doneButtonTitle: "Done")
        
//        let configuration = RatingConfiguration(ratingStyle: .FollowUp, primaryTitle1: "Thank you for feedback", primaryTitle2: nil, secondaryTitle: nil, primaryButtonTitle: "Submit", secondaryButtonTitle: nil, doneButtonTitle: nil)
        
//        let configuration = RatingConfiguration(ratingStyle: .ReviewPrompt, primaryTitle1: "Thank you for feedback", primaryTitle2: nil, secondaryTitle: nil, primaryButtonTitle: "Submit", secondaryButtonTitle: "I'll do it later", doneButtonTitle: nil)
        
        let frameworkBundle = Bundle(identifier: "Rohan-Moradiya.Feedback")
        let controller = RatingViewController(nibName: "RatingViewController", bundle: frameworkBundle)
//        let controller = RatingViewController(nibName: "RatingViewController", bundle: Bundle(for: self))
        controller.confuguration = configuration
        controller.modalPresentationStyle = .overFullScreen
        controller.view.backgroundColor = UIColor.clear
        controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        
//        fromController.present(controller, animated: false) {
//            controller.animateRatingView()
//        }
        
        if let keyWindow = UIApplication.shared.windows.first(where: {$0.isKeyWindow == true }) {
            if let rootView = keyWindow.rootViewController {
                rootView.present(controller, animated: false) {
                    controller.animateRatingView()
                }
            }
        }
        
        
//        alertWindow.rootViewController = UIViewController()
//        alertWindow.windowLevel = UIWindow.Level.alert + 1;
//        alertWindow.makeKeyAndVisible()

        
        
    }
}
