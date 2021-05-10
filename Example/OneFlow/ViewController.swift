//
//  ViewController.swift
//  OneFlowExample
//
//  Created by Rohan Moradiya on 07/05/21.
//

import UIKit
import OneFlow

let kSubscriptionIDMonthly = "product id"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SubscriptionManager.shared.completionBlock = {[weak self] (isSuccess, error) in
            if let self = self {
                if isSuccess == true {
                    print("it is success")
                } else {
                    print("premium expired")
                }
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SubscriptionManager.shared.getLocalizedPriceFor([kSubscriptionIDMonthly]) { (isSuccess, result, error) in
            
            print(result as Any)
            print(error as Any)
        }
    }
    
    @IBAction func onPurchase(_ sender: UIButton) {
        SubscriptionManager.shared.startSubscriptionWithProductionID(kSubscriptionIDMonthly)
    }
}

