//
//  StoreManager.swift
//  iOS
//
//  Created by Tinashe  on 2021/03/13.
//

import Foundation
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    
    static let shared = StoreManager()
    
    @Published var showThankYou = false
    @Published var lastProductID: String?
    
    let productIDs = ["tip_small", "tip_medium", "tip_large", "tip_xlarge", "tip_huge"]
    
    init() {
        listenForTransactions()
    }
    
    private func listenForTransactions() {
        Task {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                }
            }
        }
    }
    
}
