//
//  ViewController.swift
//  OneFlowExample
//
//  Created by Rohan Moradiya on 07/05/21.
//

import UIKit
import SkyBoxInApp

let kSubscriptionIDMonthly = "product_1_id"
let kConsumableProductID = "product_2_id"
let kNonConsumableProductID = "product_3_id"

class ViewController: UIViewController {

    @IBOutlet weak var lblSubscriptionPrice: UILabel!
    @IBOutlet weak var lblConsumablePrice: UILabel!
    @IBOutlet weak var lblNonConsumablePrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SubscriptionManager.shared.completionBlock = {[weak self] (isSuccess, error) in
            if let self = self {
                if isSuccess == true {
                    print("Purchase success")
                    //Do something after product successfully purchased
                    if let productInfo = SubscriptionManager.shared.productInfo { //SubscriptionManager.shared.productInfo {
                        print("Purchased product: ", productInfo)
                    }
                    
                } else {
                    print(error ?? "something went wrong")
                    //do something in failed case
                }
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SubscriptionManager.shared.getLocalizedPriceFor([kSubscriptionIDMonthly, kConsumableProductID, kNonConsumableProductID]) { (isSuccess, result, error) in
            if isSuccess == true, let priceData = result {
                DispatchQueue.main.async {
                    if let price = priceData[kSubscriptionIDMonthly] as? String {
                        self.lblSubscriptionPrice.text = price
                    }
                    
                    if let price = priceData[kConsumableProductID] as? String {
                        self.lblConsumablePrice.text = price
                    }
                    
                    if let price = priceData[kNonConsumableProductID] as? String {
                        self.lblNonConsumablePrice.text = price
                    }
                    
                }
            } else {
                print(error ?? "Something went wrong")
            }
        }
    }
    
    @IBAction func onPurchase(_ sender: UIButton) {
        SubscriptionManager.shared.purchaseType = .consumable
        SubscriptionManager.shared.startSubscriptionWithProductionID(kConsumableProductID)
    }
    
    @IBAction func onSubscribe(_ sender: UIButton) {
        SubscriptionManager.shared.purchaseType = .subscription
        SubscriptionManager.shared.startSubscriptionWithProductionID(kSubscriptionIDMonthly)
    }
    
    @IBAction func onPurchaseNonConsumable(_ sender: UIButton) {
        SubscriptionManager.shared.purchaseType = .nonConsumable
        SubscriptionManager.shared.nonConsumableProductID = kNonConsumableProductID
        SubscriptionManager.shared.startSubscriptionWithProductionID(kNonConsumableProductID)
    }
}

