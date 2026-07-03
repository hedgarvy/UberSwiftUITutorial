//
//  LocationSearchViewModel.swift
//  UberSwiftUITutorial
//
//  Created by Ivan Verdugo on 27/05/26.
//

import Foundation
import MapKit

@Observable
class LocationSearchViewModel: NSObject{
    var results: [MKLocalSearchCompletion] = []
    var selectedUberLocation: UberLocation?
    var pickupTime: String?
    var dropOffTime: String?
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocationSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("DEBUG: Location search failed with error \(error.localizedDescription)")
                return
            }
            
            guard let item = response?.mapItems.first else { return }
            self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: item.location.coordinate)
        }
    }
    
    func locationSearch(forLocationSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request(completion: localSearch)
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: RideTypes) -> Double {
        guard let coordinate = selectedUberLocation?.coordinate else {return 0.0 }
        guard let userLocation = userLocation else {return 0.0 }
        
        let from = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let tripDistanceInMeters = from.distance(from: destination)
        
        return type.computePrice(for: tripDistanceInMeters)
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                             to destinationCoordinate: CLLocationCoordinate2D,
                             completion: @escaping (MKRoute) -> Void){
        
        // Updated for iOS 26.0: Use MKMapItem(coordinate:) constructor instead of deprecated MKPlacemark
        let userMapItem = MKMapItem(location: .init(latitude: userLocation.latitude, longitude: userLocation.longitude), address: .none)
        let destinationMapItem = MKMapItem(location: .init(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude), address: .none)
        
        let request = MKDirections.Request()
        request.source = userMapItem
        request.destination = destinationMapItem
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let error = error  {
                print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
            }
            
            guard let route = response?.routes.first else { return }
            
            self.configurePickupAndDropOff(with: route.expectedTravelTime)
            
            completion(route)
        }
    }
    
    func configurePickupAndDropOff(with expectedTravelTime: Double){
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        //DispatchQueue.main.async {
        self.results = completer.results
        //}
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
