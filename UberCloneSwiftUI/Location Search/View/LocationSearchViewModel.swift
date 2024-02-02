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
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?
     
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment = "" {
        didSet {
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
    
    func selectLocation(searchCompletion: MKLocalSearchCompletion) {
        getLocationCoordinates(searchCompletion: searchCompletion) { coordinate in
            if let coordinate {
                self.selectedLocationCoordinate = coordinate
            }
        }
    }
    
    private func getLocationCoordinates(searchCompletion: MKLocalSearchCompletion, completionHandler: @escaping (CLLocationCoordinate2D?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: searchCompletion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            if error != nil {
                completionHandler(nil)
                return
            }
            
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                completionHandler(nil)
                return
            }
            
            completionHandler(coordinate)
        }
    }
    
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}

