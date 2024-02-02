//
//  HomeView.swift
//  UberCloneSwiftUI
//
//  Created by Mehmet Ali Kısacık on 13.07.2023.
//

import SwiftUI

struct HomeView: View {
    @State private var mapState = UberMapViewState.noInput
     
    var body: some View {
        
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                UberMapView(mapState: $mapState )
                    .ignoresSafeArea()
                if mapState == .noInput {
                    LocationSearchActivationView()
                        .padding(.top, 70)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapState = .searchingForLocation
                            }
                        }
                } else if mapState == .searchingForLocation {
                    LocationSearchView(mapState: $mapState)
                }
                
                MapViewActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top, 4)
            }
            

            if mapState == .locationSelected {
                RideRequestView(uberXPrice: .constant("$22.3"), uberBlackPrice: .constant("$24.2"), uberXLPrice: .constant("$30.5"))
                    .transition(.move(edge: .bottom))
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
