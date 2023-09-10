//
//  LocationSearchViewModel.swift
//  UberCloneSwiftUI
//
//  Created by Mehmet Ali Kısacık on 17.07.2023.
//

import Foundation
import MapKit

final class LocationSearchViewModel: NSObject, ObservableObject {
    @Published var results = [MKLocalSearchCompletion]()
     
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment = "" {
        didSet {
            print("Debug \(queryFragment)")
            
            if queryFragment.isEmpty {
                results = []
            }
            
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}

