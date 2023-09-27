//
//  UberMapView.swift
//  UberCloneSwiftUI
//
//  Created by Mehmet Ali Kısacık on 13.07.2023.
//

import SwiftUI
import MapKit

struct UberMapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    let mapView = MKMapView()
    let locationManager = LocationManager()
    
    @EnvironmentObject var locationViewModel: LocationSearchViewModel

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinate = locationViewModel.selectedLocationCoordinate {
            context.coordinator.addAndSelectAnnotation(with: coordinate)
            context.coordinator.configurePolyline(with: coordinate)
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
}

extension UberMapView {
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapView
        var userLocationCoordinate: CLLocationCoordinate2D?
        var isFirstLocationSet = false
        
        init(parent: UberMapView) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            var isFirstLocationSet = false
            
            if !isFirstLocationSet {
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                parent.mapView.setRegion(region, animated: true)
                isFirstLocationSet = true
            }
        }
        
        func addAndSelectAnnotation(with coordinate: CLLocationCoordinate2D) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.addAnnotation(annotation)
            parent.mapView.selectAnnotation(annotation, animated: true)
            
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        func configurePolyline(with destinationCoordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = userLocationCoordinate else { return }
            getDestinationRoute(from: userLocationCoordinate, to: destinationCoordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
            }
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
            directions.calculate { response, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let route = response?.routes.first else { return }
                
                completion(route)
            }
        }
        
    }
}
