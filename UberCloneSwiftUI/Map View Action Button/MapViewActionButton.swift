//
//  MapViewActionButton.swift
//  UberCloneSwiftUI
//
//  Created by Mehmet Ali Kısacık on 14.07.2023.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState: UberMapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
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
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected, .polylineAdded:
            mapState = .noInput
            viewModel.selectedUberLocation = nil

        }
    }
    
    func imageForState(_ state: UberMapViewState) -> Image {
        switch mapState {
        case .noInput:
            return Image(systemName: "line.3.horizontal")
        case .searchingForLocation, .locationSelected:
            return Image(systemName: "arrow.left")
        default:
            return Image(systemName: "line.3.horizontal")
        }
    }
    
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.noInput))
    }
}
