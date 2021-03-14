//
//  SupportView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct SupportView: View {
    
    @ObservedObject private var manager = StoreManager.shared
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    private var navTitle: String = NSLocalizedString("Support", comment: "Title")
    
    var body: some View {
        if (idiom == .phone) {
            NavigationView {
                content
                    .navigationTitle(navTitle)
            }
        } else {
            #if os(iOS)
                content
                    .navigationTitle(navTitle)
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
                    HStack(spacing: 20) {
                        Spacer()
                        ForEach(manager.donations, id: \.self) { product in
                            Button(action: {
                                let success = manager.donate(for: product)
                                debugPrint("State was: \(success)")
                            }, label: {
                                Text(product.formattedPrice)
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(.accentColor)
                                    .padding([.top, .bottom], 6)
                                    .padding([.trailing, .leading], 12)
                                    .background(
                                        RoundedRectangle(
                                            cornerRadius: 20,
                                            style: .continuous
                                        )
                                        .fill(Color(.secondarySystemBackground))
                                    )
                            })
                        }
                        Spacer()
                        
                    }
                }
                .padding([.top, .bottom], 20)
                
                Text(LocalizedStringKey("Support.Promo.Terms"))
                    .footNoteStyle()
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
        }
        .onAppear {
            manager.getProducts()
        }
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SupportView()
                .previewDevice(PreviewDevice(rawValue: "Iphone 12"))
            
            SupportView()
                .previewDevice(PreviewDevice(rawValue: "Iphone 12 Pro"))
                .preferredColorScheme(.dark)
        }
    }
}
