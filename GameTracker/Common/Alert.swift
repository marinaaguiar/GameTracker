//
//  Alert.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/13/22.
//

import Foundation
import UIKit

class Alert {

    class func showBasics(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
