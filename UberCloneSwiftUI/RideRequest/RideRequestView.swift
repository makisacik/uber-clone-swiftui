//
//  RideRequestView.swift
//  UberCloneSwiftUI
//
//  Created by Mehmet Ali Kısacık on 29.09.2023.
//

import SwiftUI

struct RideRequestView: View {
    
    @State private var selectedRideType: RideType = .uberX
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.secondaryBackground))
                .frame(width: 48, height: 6)
                .padding(8)
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
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                    Text("Where to ?")
                        .fontWeight(.semibold)
                }
                
                Spacer()
                VStack(alignment: .trailing, spacing: 24) {
                    Text("2:13 PM")
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                    Text("3:02 PM")
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                }.padding()
                
            }
            Divider()
            
            Text("SUGGESTED RIDES")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(RideType.allCases) {type in
                        VStack(alignment: .center) {
                            
                            if (type == .uberXL) {
                                Image(type.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(1.25)
                            } else {
                                Image(type.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                            Text(type.description)
                                .fontWeight(.semibold)
                            Text(String(format: "$%.1f", locationViewModel.computeRidePrice(for: type)))
                                .multilineTextAlignment(.center)
                                .fontWeight(.semibold)


                            Spacer()
                        }
                        .frame(width: 112)
                        .background(getRideTypeSelectedColor(type: type))
                        .scaleEffect(getRideTypeSelectedScale(type: type))
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedRideType = type
                            }
                        }
                    }
                }
            }.frame(height: 140)
                .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)

            HStack{
                Text("Visa")
                    .frame(width: 60, height: 40)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .padding()
                    .fontWeight(.semibold)
                
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
                .foregroundStyle(.primary)
                .fontWeight(.semibold)
                Spacer()
            }
            .frame(height: 40)
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.horizontal, 5)

        }
        .padding(.bottom, 50)
        .background(Color(.background))
        .cornerRadius(30)

    }
    
    func getRideTypeSelectedColor(type: RideType) -> Color {
        return type == selectedRideType ? Color(.systemBlue) : Color(.secondaryBackground)
    }
    
    func getRideTypeSelectedScale(type: RideType) -> Double {
        return type == selectedRideType ? 1.1 : 1.0
    }
    
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView()
    }
}
