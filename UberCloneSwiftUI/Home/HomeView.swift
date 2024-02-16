//
//  HomeView.swift
//  UberCloneSwiftUI
//
//  Created by Mehmet Ali Kısacık on 13.07.2023.
//

import SwiftUI

struct HomeView: View {
    @State private var mapState = UberMapViewState.noInput
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
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
            
            let shouldShowRideRequest = mapState == .locationSelected || mapState == .polylineAdded
            
            VStack {
                if shouldShowRideRequest {
                        RideRequestView()
                            .transition(.move(edge: .bottom))
                }
            }
            .animation(.spring, value: shouldShowRideRequest)
        }.ignoresSafeArea(edges: .bottom)
        
        .onReceive(LocationManager.shared.$userLocation,
                   perform: { location in
            debugPrint("DEBUG Location \(String(describing: location))")
            viewModel.userLocation = location
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
