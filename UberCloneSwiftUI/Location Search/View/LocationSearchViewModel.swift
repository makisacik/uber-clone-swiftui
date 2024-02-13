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
    
    var userLocation: CLLocationCoordinate2D?
    
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
    
    func selectLocation(searchCompletion: MKLocalSearchCompletion, completionHandler: @escaping () -> Void) {
        getLocationCoordinates(searchCompletion: searchCompletion) { coordinate in
            if let coordinate {
                self.selectedLocationCoordinate = coordinate
                completionHandler()
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
    
    func computeRidePrice(for type: RideType) -> Double {
        guard let destinationCoordinate = selectedLocationCoordinate else { return 0.0 }
        guard let userCoordinate = userLocation else { return 0.0 }
        
        let destination = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        
        let tripDistanceInMeters = userLocation.distance(from: destination)
        return type.computePrice(for: tripDistanceInMeters)
    }
    
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}

