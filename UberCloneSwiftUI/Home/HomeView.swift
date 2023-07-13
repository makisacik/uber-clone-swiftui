//
//  HomeView.swift
//  UberCloneSwiftUI
//
//  Created by Mehmet Ali Kısacık on 13.07.2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack(alignment: .top) {
            UberMapView()
                .ignoresSafeArea()
            
            LocationSearchActivationView()
                .padding(.top, 30)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
