//
//  InfoView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/14.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        NavigationView {
                VStack {
                    
                    List {
                        AppInfoView()
                        
                        DefaultLineItem(icon: "square.and.arrow.up",
                                        title: "Share this app...")
                        
                        DefaultLineItem(icon: "questionmark.circle",
                                        title: "Help or Feedback")
                        
                        CustomLineItem(icon: "github",
                                       title: "View source code")
                        
                        CustomLineItem(icon: "twitter",
                                       title: "Twitter")
                    }
                   
                }
            .navigationBarTitle("Info")
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

struct AppInfoView: View {
    let appVersion: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            
            VStack {
                HStack {
                    Text("Christ In Song App")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                HStack {
                    Text("v\(appVersion as? String ?? "1.0.0")")
                        .font(.caption2)
                    Spacer()
                }
                HStack {
                    Text("By Tinashe Mzondiwa")
                        .font(.body)
                    Spacer()
                }
            }
        }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 8)
    }
}

struct DefaultLineItem: View {
    var icon: String
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
                .padding(.leading, 10)
        }.padding(.leading, 12)
    }
}

struct CustomLineItem: View {
    var icon: String
    var title: String
    
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18)
                .colorMultiply(Color.primary)
            Text(title)
                .padding(.leading, 10)
        }.padding(.leading, 12)
    }
}
