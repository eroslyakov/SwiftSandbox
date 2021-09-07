//
//  ContactsView.swift
//  PersonalCard
//
//  Created by Rosliakov Evgenii on 01.08.2021.
//

import SwiftUI

struct ContactsView: View {
    
    let label: String!
    let iconName: String!
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.white)
            .frame(height: 48)
            .overlay(HStack {
                Image(systemName: iconName)
                    .padding(5)
                    .foregroundColor(Utils.mainColor)
                Text(label)
                    .font(Utils.getFont(36))
                    .foregroundColor(.black)
                    .bold()
                    .padding(5)
            }).padding()
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(label:"Hello", iconName: "phone")
            .previewLayout(.sizeThatFits)
    }
}
