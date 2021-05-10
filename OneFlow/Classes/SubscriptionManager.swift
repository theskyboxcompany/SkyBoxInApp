//
//  SubscriptionManager.swift
//  Ad Blocker
//
//  Created by Rohan Moradiya on 25/02/21.
//

import Foundation
import StoreKit


public class SubscriptionManager: NSObject {

    static public let shared = SubscriptionManager()
    /// Notification will be posted when user activates the subscription
    static let kPremiumActivateNotification = Notification.Name("PremiumSubscriptionActivated")
    
    public var isPremiumUser = false {
        didSet {
            UserDefaults.standard.setValue(isPremiumUser, forKey: "isPremiumUser")
        }
    }
    
    public  var completionBlock: ((Bool, String?) -> Void)?
    private var currentProductID: String?
    var isReceiptRefreshed = false
    var isReceiptRefreshing = false
    var isForBuying = false
    private var isToFindProductsOnly = false
    private var productFetchCompletion: ((Bool, [String: Any]?, String?) -> Void)?
    
    private override init() {
        super.init()
        if UserDefaults.standard.value(forKey: "WasPremiumActivated") == nil {
            UserDefaults.standard.set(false, forKey: "WasPremiumActivated")
        }
        SKPaymentQueue.default().add(self)
    }
    
    // use this function to get the current user premium status (true means premium is active)
    public func getUserPremiumStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "isPremiumUser")
    }
    
    public func getLocalizedPriceFor(_ identifires: [String], completion: @escaping (Bool, [String: Any]?, String?) -> Void) {
        self.isToFindProductsOnly = true
        self.productFetchCompletion = completion
        let productIDs = Set(identifires)
        let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productIDs)
        productsRequest.delegate = self
        productsRequest.start()
        
    }
    public func restoreCompletedTransactions() {
        self.isToFindProductsOnly = false
        self.isForBuying = false
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    public func startSubscriptionWithProductionID(_ productID: String) {
        self.isForBuying = true
        self.isToFindProductsOnly = false
        print("subscription started")
        if (SKPaymentQueue.canMakePayments()) {
            self.currentProductID = productID
            let productID = Set(arrayLiteral: productID)
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID)
            productsRequest.delegate = self
            productsRequest.start()
        } else {
            if let completion = self.completionBlock {
                completion(false, "Can not make payments")
            }
        }
    }
    
    private func buyProduct(_ product: SKProduct) {
        print("buyProduct")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    private func refreshIAPReceipt() {
        print("Refreshing receipt")
        self.isReceiptRefreshing = true
        let request = SKReceiptRefreshRequest(receiptProperties: nil)
            request.delegate = self
        
            request.start()
    }
    public func verifyReceipt() { //_ completion: @escaping(Bool, String?) -> Void) {

        print("Verifying receipt")
        self.isToFindProductsOnly = false
        let receiptValidator = ReceiptValidator()
        let validationResult = receiptValidator.validateReceipt()
                
        switch validationResult {
        case .success(let parsedReceipt):
            print("successfully validated receipt. Checking subscription dates")

            print("Parsed Receipt: \(parsedReceipt)")
            if let receipts = parsedReceipt.inAppPurchaseReceipts {
                self.isPremiumUser = false
                for r in receipts {
                    if let expirationDate = r.subscriptionExpirationDate {
                        let now = Date()
                        if expirationDate > now {
                            print("Subscription is active")
                            self.isPremiumUser = true
                            break
                        } else {
                            
                        }
                    }
                }
                if self.isPremiumUser == true {
                    //Post notification if user is not premium
                    if UserDefaults.standard.bool(forKey: "WasPremiumActivated") == false {
                        NotificationCenter.default.post(name: SubscriptionManager.kPremiumActivateNotification, object: nil)
                    }
                    UserDefaults.standard.set(true, forKey: "WasPremiumActivated")
                    if let completion = self.completionBlock {
                        completion(true, nil)
                    }
                } else if self.isReceiptRefreshed == false {
                    print("Subscription is not active. Trying to refresh receipt")
                    if isReceiptRefreshed == false {
                        self.refreshIAPReceipt()
                    }
                } else {
                    print("Subscription is not active.")
                    UserDefaults.standard.set(false, forKey: "WasPremiumActivated")
                    if let completion = self.completionBlock {
                        completion(false, "Subscription expired")
                    }
                    
                }
            }
            break
        case .error(let error):
            print(error)
            self.isPremiumUser = false
            if let completion = self.completionBlock {
                completion(false, error.localizedDescription)
            }
            
            break
        }
    }
    
    private func priceStringForProduct(item: SKProduct) -> String? {
        let price = item.price
        if price == NSDecimalNumber(decimal: 0.00) {
            return "0.0"
        } else {
            let numberFormatter = NumberFormatter()
            let locale = item.priceLocale
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = locale
            return numberFormatter.string(from: price)
        }
    }
}

extension SubscriptionManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("productsRequest received resposne")
        
        if isToFindProductsOnly == true {
            if response.products.count == 0 {
                if let completion = self.productFetchCompletion {
                    completion(false, nil, "Product not found")
                }
                return
            }
            var finalResult = [String: Any]()
            response.products.forEach { (product) in
                finalResult[product.productIdentifier] = self.priceStringForProduct(item: product)
            }
            if let completion = self.productFetchCompletion {
                completion(true, finalResult, nil)
            }
            return
        }
        
        let count : Int = response.products.count
        if (count > 0) {
            let product = response.products[0] as SKProduct
            if product.productIdentifier == self.currentProductID {
                self.buyProduct(product)
            } else {
                print(product.productIdentifier)
                if let completion = self.completionBlock {
                    completion(false, "Product id does not match")
                }
            }
        } else {
            if let completion = self.completionBlock {
                completion(false, "Product not found")
            }
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request failed with error: \(error.localizedDescription)")
        if request is SKReceiptRefreshRequest {
            if let completion = self.completionBlock {
                completion(false, "Subscription expired")
            }
        } else {
            
            if isToFindProductsOnly == true {
                if let completion = self.productFetchCompletion {
                    completion(false, nil, error.localizedDescription)
                }
                return
            }
            
            if let completion = self.completionBlock {
                completion(false, error.localizedDescription)
            }
        }
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        print("Request did finish")
        if request is SKReceiptRefreshRequest {
            self.isReceiptRefreshed = true
            self.isReceiptRefreshing = false
            self.verifyReceipt()
        }
    }
}

extension SubscriptionManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("payment queue update transactions")
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased:
                print("payment queue: purchased")
                SKPaymentQueue.default().finishTransaction(transaction)
                if self.isReceiptRefreshing == false {
                    self.verifyReceipt()
                }
                break
            case .failed:
                print("payment queue: Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                if let completion = self.completionBlock {
                    completion(false, "Transaction failed")
                }
                break
            case .restored:
                print("payment queue: restored")
                SKPaymentQueue.default().finishTransaction(transaction)
                //In case of manual restore, This state will be called many times. So don't verify receipt every time. It will be verified in "paymentQueueRestoreCompletedTransactionsFinished".
                //If product is restore when user is buying it, then verify receipt.
                //While buying product, It some times call this states. So verify receipt after that. In sandbox environment, It might have not refreshed receipt. So May be local receipt verification will be failed. If we try again 1-2 times then it will work.
                if self.isForBuying == true {
                    self.verifyReceipt()
                }
                
            default:
                break;
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("payment queue: restoring failed. error: \(error.localizedDescription)")
        if let completion = self.completionBlock {
            completion(false, error.localizedDescription)
        }
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("payment queue: restore completed")
        for transact:SKPaymentTransaction in queue.transactions {
            if transact.transactionState == .restored {
                SKPaymentQueue.default().finishTransaction(transact)
            }
        }
        self.isReceiptRefreshed = true
        self.verifyReceipt()
    }
}
