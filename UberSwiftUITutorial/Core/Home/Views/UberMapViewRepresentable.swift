//
//  UberMapViewRepresentable.swift
//  UberSwiftUITutorial
//
//  Created by Ivan Verdugo on 22/05/26.
//

import SwiftUI
import MapKit

struct UberMapViewRepresentable: UIViewRepresentable {
    let mapView = MKMapView()
    @Binding var mapState: MapViewState
    @Environment(LocationSearchViewModel.self) var locationViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterUserLocation()
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = locationViewModel.selectedUberLocation?.coordinate {
                print("DEBUG: Adding stuf to map...")
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyLine(withDestinationCoordinate: coordinate)
            }
        case .polylineAdded:
            break 
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension UberMapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        //MARK: - delegates
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            
            //ajustar el zoom de la ubicacion del usuario
            let region  =  MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )

            self.currentRegion = region
            self.parent.mapView.setRegion(region, animated: true)
        }
        
        //delegate que se necesita para dibujar la route
        func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            
            return polyline
        }
        
        //MARK: - Helpers
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            self.parent.mapView.removeAnnotations(self.parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
        }
        
        func configurePolyLine(withDestinationCoordinate coordinate: CLLocationCoordinate2D){
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                let rect =  self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: CGFloat(64), left: CGFloat(32), bottom: CGFloat(500), right: CGFloat(32)))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func clearMapViewAndRecenterUserLocation(){
            guard let currentRegion = self.currentRegion else { return }
            
            self.parent.mapView.removeAnnotations(self.parent.mapView.annotations)
            self.parent.mapView.removeOverlays(self.parent.mapView.overlays)
            self.parent.mapView.setRegion(currentRegion, animated: true)
        }
    }
    
}

