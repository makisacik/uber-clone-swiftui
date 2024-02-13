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
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropoffTime: String?
    
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
                self.selectedUberLocation = UberLocation(title: searchCompletion.title, coordinate: coordinate)
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
        guard let destinationCoordinate = selectedUberLocation?.coordinate else { return 0.0 }
        guard let userCoordinate = userLocation else { return 0.0 }
        
        let destination = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        
        let tripDistanceInMeters = userLocation.distance(from: destination)
        return type.computePrice(for: tripDistanceInMeters)
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                             to destination: CLLocationCoordinate2D,
                             completion: @escaping (MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            
            guard let route = response?.routes.first else { return }
            self?.configurePickoffAndDropoffTimes(with: route.expectedTravelTime.magnitude)
            completion(route)
        }
    }
    
    func configurePickoffAndDropoffTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickupTime = formatter.string(from: Date())
        dropoffTime = formatter.string(from: Date() + expectedTravelTime)

    }
    
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}

