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
                        Section(header: Text("About")) {
                            Button(action: {
                                UIApplication.shared.open(URL(string: "https://github.com/TinasheMzondiwa/cis-ios")!)
                                
                                
                            }, label: {
                                CustomLineItem(title: "Github")
                            })
                            
                            Button(action: {
                                UIApplication.shared.open(URL(string: "https://twitter.com/christinsongapp")!)
                            }, label: {
                                CustomLineItem(title: "Twitter", title2: "@christinsongapp")
                            })
                        }
                        Section(header: Text("More")) {
                            if MFMailComposeViewController.canSendMail() {
                                Button(action: {
                                    showingEmailSheet.toggle()
                                }, label: {
                                    CustomLineItem(title: "Help or Feedback?")
                                })
                                .sheet(isPresented: $showingEmailSheet) {
                                    MailView(result: self.$result)
                                }
                            }
                            
                            Button(action: {
                                UIApplication.shared.open(URL(string: "https://apps.apple.com/za/app/christ-in-song-multi-language/id1067718185")!)
                            }, label: {
                                CustomLineItem(title: "Write Review")
                            })
                            Button(action: {
                                showingShareSheet.toggle()
                            }, label: {
                                CustomLineItem(title: "Share this app...")
                            })
                            .sheet(isPresented: $showingShareSheet) {
                                let shareData: [Any] = ["Install the Christ In Song App", URL(string: "https://goo.gl/72bu2H")!]
                                ActivityViewController(items: shareData)
                            }
                        }
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
        InfoView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
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
                Text("Christ In Song App")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(getAppVersion())
                    .font(.system(.caption2, design: .rounded))
            }
        }.padding(8)
    }
    
    private func getAppVersion() -> String {
        let versionShort: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let versionCode: AnyObject? = Bundle.main.infoDictionary?["CFBundleVersion"] as AnyObject
        
        if let short = versionShort as? String, let code = versionCode as? String {
            return "v\(short) (\(code))"
        } else {
            return ""
        }
    }
}

struct CustomLineItem: View {
    let title: String
    var title2: String? = nil
    
    var body: some View {
        HStack {
            Text(title)
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
