//
//  SupportView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI
import StoreKit

struct SupportView: View {
    
    @EnvironmentObject var manager: StoreManager
    @Environment(\.horizontalSizeClass) private var sizeClass: UserInterfaceSizeClass?
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    private var navTitle: String = NSLocalizedString("Support.Promo.Title", comment: "Title")
    
    var body: some View {
        if (idiom == .phone) {
            NavigationView {
                content
                    .navigationTitle(navTitle)
            }
        } else {
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
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 20) {
                        Spacer()
                        
                        ForEach(manager.productIDs, id: \.self) { product in
                            ProductView(id: product)
                                .productViewStyle(.regular)
                                    .padding()
                                    .cornerRadius(16)
                        }
                        
                        Spacer()
                        
                    }
                }
                .padding([.top, .bottom], 20)
                
                Text(LocalizedStringKey("Support.Promo.Terms"))
                    .footNoteStyle()
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack(spacing: 16) {
                    Link(LocalizedStringKey("Support.Terms"), destination: URL(string: WebLink.appleTerms.rawValue)!)
                    Link(LocalizedStringKey("Support.Privacy"), destination: URL(string: WebLink.policy.rawValue)!)
                }
                .font(.footnote.weight(.medium))
            }
            
        }
        .padding(.horizontal, sizeClass == .regular ? 32 : 0)
        .sheet(isPresented: $manager.showThankYou) {
            ThankYouView(productID: manager.lastProductID)
        }
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView()
            .environmentObject(StoreManager.shared)
    }
}
