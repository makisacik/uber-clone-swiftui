//
//  RideRequestView.swift
//  UberCloneSwiftUI
//
//  Created by Mehmet Ali Kısacık on 29.09.2023.
//

import SwiftUI

struct RideRequestView: View {
    @Binding var uberXPrice: String
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.secondaryBackground))
                .frame(width: 48, height: 6)
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray))
                        .frame(width: 6, height: 6)
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(width: 1, height: 24)
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(width: 6, height: 6)
                }.padding()
                
                VStack(alignment: .leading, spacing: 24) {
                    Text("Current Location")
                    Text("Where to ?")
                }
                
                Spacer()
                VStack(alignment: .leading, spacing: 24) {
                    Text("2:13 PM")
                    Text("3:02 PM")
                }.padding()
                
            }
            Divider()
            
            Text("SUGGESTED RIDES")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                VStack {
                    
                    Image(.uberXIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("UberX")
                    TextField("Value", text: $uberXPrice)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .background(Color(.secondaryBackground))
                .cornerRadius(10)
                .padding(.horizontal, 5)
                
                VStack {
                    Image("UberBlack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("Uber Black")
                    TextField("Value", text: $uberXPrice)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .background(Color(.secondaryBackground))
                .cornerRadius(10)
                .padding(.horizontal, 5)
                
                VStack {
                    Image("UberXIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(1.3)
                    Spacer()
                    Text("UberXL")
                    TextField("Value", text: $uberXPrice)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .background(Color(.secondaryBackground))
                .cornerRadius(10)
                .padding(.horizontal, 5)
                
            }.frame(height: 140)
                .padding(.horizontal, 7 )
            
            Divider()
                .padding(.vertical, 8)

            HStack{
                Text("Visa")
                    .frame(width: 60, height: 40)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .padding()
                
                Text("****1234")
                    .font(.bold(.body)())
                Spacer()
                Image(systemName: "chevron.right")
                    .padding()
            }
            .frame(height: 60)
            .background(Color(.secondaryBackground))
            .cornerRadius(10)
            .padding(.horizontal, 5)
            
            HStack {
                Spacer()
                Button("CONFIRM RIDE") {
                    
                }
                .foregroundColor(Color.primary)
                Spacer()
            }
            .frame(height: 50)
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.horizontal, 5)

        }
        .background(Color(.background))
    }
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView(uberXPrice: .constant("$22.3"))
    }
}
