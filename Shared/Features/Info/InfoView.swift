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
        List {
           // Section(header:  AppInfoView()) {
            
            AppInfoView()
               
                Button(action: {
                    showingShareSheet.toggle()
                }, label: {
                    Label("Share this app...", systemImage: "square.and.arrow.up")
                        .foregroundColor(Color.primary)
                        .padding(.leading, 12)
                })
                .sheet(isPresented: $showingShareSheet) {
                    let shareData: [Any] = ["Install the Christ In Song App", URL(string: "https://goo.gl/72bu2H")!]
                    ActivityViewController(items: shareData)
                }
                
                Button(action: {
                    showingEmailSheet.toggle()
                }, label: {
                    Label("Help or Feedback?", systemImage: "questionmark.circle")
                        .foregroundColor(Color.primary)
                        .padding(.leading, 12)
                })
                .disabled(!MFMailComposeViewController.canSendMail())
                .sheet(isPresented: $showingEmailSheet) {
                    MailView(result: self.$result)
                }
                
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://github.com/TinasheMzondiwa/cis-ios")!)
                }, label: {
                    CustomLineItem(icon: "github",
                                   title: "View source code")
                })
                
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://twitter.com/christinsongapp")!)
                }, label: {
                    CustomLineItem(icon: "twitter",
                                   title: "Twitter")
                })
        //    }
        
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}

struct AppInfoView: View {
    private let appVersion: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            
            VStack(alignment: .leading) {
                Text("Christ In Song App")
                    .font(.title3)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text("v\(appVersion as? String ?? "1.0.0")")
                    .font(.caption2)
                Text("By Tinashe Mzondiwa")
                    .font(.caption)
            }
        }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 8)
    }
}

struct CustomLineItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18)
            
            Text(title)
                .padding(.leading, 10)
            
        }.padding(.leading, 16)
        .foregroundColor(Color.primary)
    }
}
