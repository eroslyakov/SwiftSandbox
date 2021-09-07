//
//  ContentView.swift
//  PersonalCard
//
//  Created by Rosliakov Evgenii on 01.08.2021.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack {
            Utils.mainColor
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Image("avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200, alignment: .top)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                Text("Eugene")
                    .font(Utils.getFont(64))
                    .foregroundColor(Color.white)
                    .bold()
                Text("iOS Developer (almost)")
                    .foregroundColor(.white)
                    .font(Utils.getFont(32))
                Divider()
                ContactsView(label: "+7- 991 -116 -47 -06", iconName: "phone.fill")
                ContactsView(label: "eroslyakov94@gmail.com", iconName: "envelope.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
