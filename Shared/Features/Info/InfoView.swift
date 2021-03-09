//
//  InfoView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI
import MessageUI

struct InfoView: View {
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @State private var showingShareSheet = false
    @State private var showingEmailSheet = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    private var navTitle = "Info"
    
    @ViewBuilder
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
        GeometryReader { g in
            ScrollView {
                VStack(spacing: 0) {
                    AppInfoView()
                    
                    List {
                        Section(header: Text(LocalizedStringKey("Info.About"))) {
                            Button(action: {
                                UIApplication.shared.open(URL(string: WebLink.github.rawValue)!)
                                
                                
                            }, label: {
                                CustomLineItem(title: "Info.Github")
                            })
                            
                            Button(action: {
                                UIApplication.shared.open(URL(string: WebLink.twitter.rawValue)!)
                            }, label: {
                                CustomLineItem(title: "Info.Twitter", title2: WebLink.twitterUsername.rawValue)
                            })
                        }
                        Section(header: Text(LocalizedStringKey("Info.More"))) {
                            if MFMailComposeViewController.canSendMail() {
                                Button(action: {
                                    showingEmailSheet.toggle()
                                }, label: {
                                    CustomLineItem(title: "Info.Help")
                                })
                                .sheet(isPresented: $showingEmailSheet) {
                                    MailView(result: self.$result)
                                }
                            }
                            
                            Button(action: {
                                UIApplication.shared.open(URL(string: WebLink.appStore.rawValue)!)
                            }, label: {
                                CustomLineItem(title: "Info.Review")
                            })
                            Button(action: {
                                showingShareSheet.toggle()
                            }, label: {
                                CustomLineItem(title: "Info.Share")
                            })
                            .sheet(isPresented: $showingShareSheet) {
                                let shareData: [Any] = [NSLocalizedString("Info.Share.Prompt", comment: "Share Prompt"), URL(string: WebLink.appStoreShort.rawValue)!]
                                ActivityViewController(items: shareData)
                            }
                        }
                        
                        Text(LocalizedStringKey("Info.About.Description"))
                            .multilineTextAlignment(.center)
                            .footNoteStyle()
                            .listRowBackground(Color(.systemGroupedBackground))
                    }
                    .listStyle(InsetGroupedListStyle())
                    .frame(width: g.size.width, height: g.size.height, alignment: .center)
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InfoView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
            
            InfoView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
    }
}

struct AppInfoView: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64)
                .cornerRadius(12)
            
            VStack(alignment: .center) {
                Text(LocalizedStringKey("Common.App.Name"))
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(Constants.getAppVersion())
                    .font(.system(.caption2, design: .rounded))
            }
        }.padding(8)
    }
}

struct CustomLineItem: View {
    let title: String
    var title2: String? = nil
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
                .bodyStyle()
            Spacer()
            
            if let title2 = title2 {
                Text(title2)
                    .subHeadLineStyle()
            }
            
            SFSymbol.chevronRight
                .subHeadLineStyle()
        }
    }
}
