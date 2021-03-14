//
//  StoreManager.swift
//  iOS
//
//  Created by Tinashe  on 2021/03/13.
//

import Foundation
import StoreKit
import Combine

enum PurchaseState {
    case processing
    case success
    case error
}

class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate {
    
    static let shared = StoreManager()
    
    let purchasePublisher = PassthroughSubject<(String, PurchaseState), Never>()
    
    @Published var donations = [SKProduct]()
    
    func getProducts() {
        let productIDs = ["tip_small", "tip_medium", "tip_large"]
        
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Did receive response")
            
        if !response.products.isEmpty {
            DispatchQueue.main.async {
                self.donations = response.products.sorted(by: {$0.formattedPrice < $1.formattedPrice})
            }
        }
    }
    
    func donate(for product: SKProduct) -> Bool {
        if !canMakePayments() {
            return false
        } else {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
        return true
    }
}

extension SKProduct {
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price) ?? ""
    }
}

extension StoreManager: SKPaymentTransactionObserver {
    private func canMakePayments() -> Bool {
      return SKPaymentQueue.canMakePayments()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                purchasePublisher.send(("Thank you! ", .success))
            case .failed:
                if let error = transaction.error as? SKError {
                    purchasePublisher.send(("Payment Error \(error.code) ", .error))
                    debugPrint("Payment Failed \(error.code)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                debugPrint("Ask Mom ...")
                purchasePublisher.send(("Payment Diferred", .error))
            case .purchasing:
                debugPrint("working on it...")
                purchasePublisher.send(("Payment in Process", .processing))
            default:
                break
            }
        }
    }
    
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }
    
    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
}
