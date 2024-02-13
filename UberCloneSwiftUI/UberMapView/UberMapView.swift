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
    @Binding var mapState: UberMapViewState
    let locationManager = LocationManager.shared
    
    @EnvironmentObject var locationViewModel: LocationSearchViewModel

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("update map state \(mapState)")
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewPolylineAndSetRegion()
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = locationViewModel.selectedLocationCoordinate {
                context.coordinator.addAndSelectAnnotation(with: coordinate)
                context.coordinator.configurePolyline(with: coordinate)
            }
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
        var currentRegion: MKCoordinateRegion?
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
                self.currentRegion = region
                parent.mapView.setRegion(region, animated: true)
                isFirstLocationSet = true
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        func addAndSelectAnnotation(with coordinate: CLLocationCoordinate2D) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.addAnnotation(annotation)
            parent.mapView.selectAnnotation(annotation, animated: true)
            
        }
        
        func configurePolyline(with destinationCoordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = userLocationCoordinate else { return }
            getDestinationRoute(from: userLocationCoordinate, to: destinationCoordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 32, bottom: 520, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
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
        
        func clearMapViewPolylineAndSetRegion() {
            parent.mapView.removeOverlays(parent.mapView.overlays)
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            if let currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        
    }
}
