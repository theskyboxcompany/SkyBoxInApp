# SkyBoxInApp

[![CI Status](https://img.shields.io/travis/rohantryskybox/SkyBoxInApp.svg?style=flat)](https://travis-ci.org/rohantryskybox/SkyBoxInApp)
[![Version](https://img.shields.io/cocoapods/v/SkyBoxInApp.svg?style=flat)](https://cocoapods.org/pods/SkyBoxInApp)
[![License](https://img.shields.io/cocoapods/l/SkyBoxInApp.svg?style=flat)](https://cocoapods.org/pods/SkyBoxInApp)
[![Platform](https://img.shields.io/cocoapods/p/SkyBoxInApp.svg?style=flat)](https://cocoapods.org/pods/SkyBoxInApp)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SkyBoxInApp is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
  pod 'SkyBoxInApp'
```
- To validate the receipt locally, Library will require "AppleIncRootCertificate.cer" to be in main application bundle.
To download the certificate Go to https://www.apple.com/certificateauthority/ and click on "AppleIncRootCertificate.cer". Once certificate is downloaded add it into your main bundle.
## How to use

- To check if user is already subscribed, assigned this completion block and call verifyReceipt()
```ruby
SubscriptionManager.shared.completionBlock = {[weak self] (isSuccess, error) in
            if let self = self {
                if isSuccess == true {
                    print("It is premium subscription")
                } else {
                    print("premium expired")
                }
            }
        }
        SubscriptionManager.shared.verifyReceipt()
```
If you are also dealing with non consumable product, then assing product id before calling verifyReceipt()
```ruby
SubscriptionManager.shared.nonConsumableProductID = "Product ID"
```
- Before starting subscription, Assign completion block like
```ruby
SubscriptionManager.shared.completionBlock = {[weak self] (isSuccess, error) in
            if let self = self {
                if isSuccess == true {
                    print("Purchase success")
                    //Do something after product successfully purchased
                } else {
                    print(error ?? "something went wrong")
                    //do something in failed case
                }
            }
        }
```
After setting above completion block,
- To Buy consumable product,
```ruby
SubscriptionManager.shared.purchaseType = .consumable
SubscriptionManager.shared.startSubscriptionWithProductionID("Product ID")
```
- To Buy subscription based product either auto-renewable or non-renewable
```ruby
SubscriptionManager.shared.purchaseType = .subscription
SubscriptionManager.shared.startSubscriptionWithProductionID("Product ID")
```
- To Buy non-consumable product,
```ruby
SubscriptionManager.shared.purchaseType = .nonConsumable
SubscriptionManager.shared.nonConsumableProductID = "Product ID"
SubscriptionManager.shared.startSubscriptionWithProductionID("Product ID")
```
Once process is completed, It will call above assigned completion block with either success or error.

- To find the product details which subscribed
Note - "productInfo" only available for Subscription or non-consumable products
```ruby
if let productInfo = SubscriptionManager.shared.productInfo {
    print("Purchased product: ", productInfo)
}
```
- To find localized price of products
```ruby
SubscriptionManager.shared.getLocalizedPriceFor(["Product ID 1", "Product ID 2", "Product ID 3"]) { (isSuccess, result, error) in
            if isSuccess == true, let priceData = result {
                DispatchQueue.main.async {
                    
                }
            } else {
                print(error ?? "Something went wrong")
            }
        }
```
Here priceData will be [String: String] dictionary where keys will be product id and values are price.

- To Restore already purchased product
```ruby
SubscriptionManager.shared.restoreCompletedTransactions()
```
It will call above assigned completion block
```ruby
SubscriptionManager.shared.completionBlock = {[weak self] (isSuccess, error) in
}
```
Note - Assign "purchaseType" and "nonConsumableProductID" if you are dealing with such product types.

## Author

rohantryskybox, rohan@tryskybox.com

## License

SkyBoxInApp is available under the MIT license. See the LICENSE file for more info.
