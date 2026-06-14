//
//  SupportView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI
import StoreKit
import FirebaseAnalytics

struct SupportView: View {
    
    @EnvironmentObject var manager: StoreManager
    @StateObject private var bannerManager = BannerManager.shared
    
    private var navTitle: String = NSLocalizedString("Support.Promo.Title", comment: "Title")
    
    var body: some View {
#if os(iOS)
        NavigationStack {
            content
                .navigationTitle(navTitle)
        }
#else
        content
            .frame(minWidth: 300, idealWidth: 500)
#endif
    }
    
    var content: some View {
        ScrollView {
            VStack {
                Image("SupportImg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Text(LocalizedStringKey("Support.Promo.Desc"))
                    .bodyStyle()
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.horizontal, 32)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 20) {
                        Spacer()
                        
                        ForEach(manager.productIDs, id: \.self) { product in
                            ProductView(id: product)
                                .productViewStyle(.regular)
                                .onInAppPurchaseCompletion { _, result in
                                    if case .success(let purchaseResult) = result,
                                       case .success(let verificationResult) = purchaseResult,
                                       case .verified(let transaction) = verificationResult {
                                        manager.lastProductID = transaction.productID
                                        manager.showThankYou = true
                                        
                                        Analytics.logTransaction(transaction)
                                        await transaction.finish()
                                    }
                                }
                                .padding()
                                .background(.background)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(.separator, lineWidth: 1)
                                )
                        }
                        
                        Spacer()
                        
                    }
                }
                .padding([.top, .bottom], 20)
                
                Text(LocalizedStringKey("Support.Promo.Terms"))
                    .footNoteStyle()
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.horizontal, 32)
                
                HStack(spacing: 16) {
                    Link(LocalizedStringKey("Support.Terms"), destination: URL(string: WebLink.appleTerms.rawValue)!)
                    Link(LocalizedStringKey("Support.Privacy"), destination: URL(string: WebLink.policy.rawValue)!)
                }
                .font(.footnote.weight(.medium))
            }
            
            Spacer()
                .frame(height: 100)
            
        }
        .sheet(isPresented: $manager.showThankYou) {
            ThankYouView(productID: manager.lastProductID)
        }
        .onChange(of: manager.showThankYou) { _, showThankYou in
            if showThankYou {
                bannerManager.dismissBanner()
            }
        }
        .task {
            AnalyticsManager.shared.logScreen(name: "SupportView")
        }
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView()
            .environmentObject(StoreManager.shared)
    }
}
