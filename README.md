# OneFlow

[![CI Status](https://img.shields.io/travis/rohantryskybox/OneFlow.svg?style=flat)](https://travis-ci.org/rohantryskybox/OneFlow)
[![Version](https://img.shields.io/cocoapods/v/OneFlow.svg?style=flat)](https://cocoapods.org/pods/OneFlow)
[![License](https://img.shields.io/cocoapods/l/OneFlow.svg?style=flat)](https://cocoapods.org/pods/OneFlow)
[![Platform](https://img.shields.io/cocoapods/p/OneFlow.svg?style=flat)](https://cocoapods.org/pods/OneFlow)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

OneFlow is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

source 'https://github.com/theskyboxcompany/1flow-specs'
#Add below line if you are also using other public pods
source 'https://github.com/CocoaPods/Specs.git'

target 'OneFlowPodExample' do
  use_frameworks!

  pod 'OneFlow'
end
```
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

- To find localized of products
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
## Author

rohantryskybox, rohan@tryskybox.com

## License

OneFlow is available under the MIT license. See the LICENSE file for more info.
