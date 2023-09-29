//
//  MapViewActionButton.swift
//  UberCloneSwiftUI
//
//  Created by Mehmet Ali Kısacık on 14.07.2023.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState: UberMapViewState
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState(mapState)
            }
        } label: {
            imageForState(mapState)
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
    
    func actionForState(_ state: UberMapViewState) {
        switch mapState {
        case .noInput:
            print("no input")
        case .searchingForLocation, .locationSelected:
            mapState = .noInput
        } 
    }
    
    func imageForState(_ state: UberMapViewState) -> Image {
        switch mapState {
        case .noInput:
            return Image(systemName: "line.3.horizontal")
        case .searchingForLocation, .locationSelected:
            return Image(systemName: "arrow.left")
        }
    }
    
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.noInput))
    }
}
