//
//  LocationSearchView.swift
//  UberCloneSwiftUI
//
//  Created by Mehmet Ali Kısacık on 14.07.2023.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @Binding var mapState: UberMapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        VStack {
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
                }
                VStack {
                    TextField("Current Location", text: $startLocationText)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                    
                    TextField("Where to ?", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                }
            }
            .padding(.horizontal)
            .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { result in
                        LocationSearchResultCell(title: result.title, subTitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring(), {
                                    viewModel.selectLocation(searchCompletion: result, completionHandler: {
                                        self.mapState = .locationSelected
                                    })
                                })
                            }
                    }
                }
            }
            
        }.background(Color(.systemBackground))
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(mapState: .constant(.searchingForLocation))
    }
}
