//
//  LocationSearchResultCell.swift
//  UberCloneSwiftUI
//
//  Created by Mehmet Ali Kısacık on 14.07.2023.
//

import SwiftUI

struct LocationSearchResultCell: View {
    let title: String
    let subTitle: String
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(Color.blue)
                .tint(.white)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title) 
                    .font(.body)
                Text(subTitle)
                    .font(.system(size: 15))
                    .foregroundColor(Color(.systemGray))
                Divider()
            }
            .padding(.leading, 8)
            .padding(.vertical, 8)
        }
        .padding(.leading)
    }
}

struct LocationSearchResultCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchResultCell(title: "title", subTitle: "subTitle")
    }
}

