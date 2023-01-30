//
//  StoreManager.swift
//  iOS
//
//  Created by Tinashe  on 2021/03/13.
//

import Foundation
import StoreKit
import Combine

enum PurchaseState: String {
    case processing = "info.circle"
    case success = "checkmark.circle"
    case error = "xmark.octagon.fill"
}

extension PurchaseState {
    var alert: AlertState {
        switch self {
        case .processing:
            return .info
        case .success:
            return .success
        case .error:
            return .error
        }
    }
}

class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate {
    
    static let shared = StoreManager()
    
    let purchasePublisher = PassthroughSubject<(message: String, state: PurchaseState), Never>()
    
    @Published var donations = [SKProduct]()
    
    func getProducts() {
        let productIDs = ["tip_small", "tip_medium", "tip_large", "tip_xlarge", "tip_huge"]
        
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
            DispatchQueue.main.async {
                self.donations = response.products.sorted(by: { $0.price.compare($1.price) == .orderedAscending })
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
                    purchasePublisher.send(("Payment Failed [\(error.errorCode)]", .error))
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                purchasePublisher.send(("Payment Diferred", .error))
            case .purchasing:
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
