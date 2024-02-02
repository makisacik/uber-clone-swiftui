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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
