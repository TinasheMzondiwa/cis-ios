//
//  CISAppViewModel.swift
//  iOS
//
//  Created by George Nyakundi on 10/03/2023.
//

import Foundation

final class CISAppViewModel: ObservableObject {
    // MARK: - Properties
    private let store: Store
    
    // MARK: - Initialization
    init(store: Store) {
        self.store = store
    }
    
    // MARK: - Private
}
