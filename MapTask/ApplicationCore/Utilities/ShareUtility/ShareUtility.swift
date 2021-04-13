//
//  ShareUtility.swift
//
//  Created by Ahmed AbdEl-Samie on 12/13/17.
//
//

import Foundation
import UIKit

class ShareUtility {
    class func shareMessage(_ message: String, inViewController:UIViewController) {
        let objectsToShare = [message]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.openInIBooks]
        activityVC.navigationController?.navigationBar.tintColor = .white
        inViewController.present(activityVC, animated: true, completion: nil)
    }
}
