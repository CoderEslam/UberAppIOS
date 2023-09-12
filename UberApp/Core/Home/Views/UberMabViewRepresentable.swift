//
//  UberMabViewRepresentable.swift
//  UberApp
//
//  Created by Eslam Ghazy on 18/8/23.
//

import SwiftUI
import MapKit

//https://developer.apple.com/documentation/swiftui/uiviewrepresentable
struct UberMabViewRepresentable: UIViewRepresentable{
    
    let mapView = MKMapView()
    let locationManger = LocationManger()
    @Binding var mapState : MapViewState
    // to get only one instance from this object  and be listin on change
    @EnvironmentObject var locationSearchViewModel : LocationSearchViewViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        
        /**
         case none = 0 // the user's location is not followed

         case follow = 1 // the map follows the user's location

         case followWithHeading = 2 // the map follows the user's location and heading
         */
        
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    
    // we use it to updating ui view -> map 
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("Debug Map is : \(mapState )")
        if let selectedLocationCoordinate = locationSearchViewModel.selectedLocationCoordinate {
            print("Selected Location \(selectedLocationCoordinate)")
            context.coordinator.addAndSelectAnnotation(setCoordinate: selectedLocationCoordinate)
            context.coordinator.configurePloyline(setDestinationCoordinate: selectedLocationCoordinate)
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}


extension UberMabViewRepresentable {
    class MapCoordinator : NSObject , MKMapViewDelegate{
        
        // MAKR: - properties
        let parent :UberMabViewRepresentable
        var userLocationCoordinate : CLLocationCoordinate2D?
        // MARK: - LifeCycle
        init(parent: UberMabViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        
        // MARK: - MKMAPViewDelegate
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            // to access user location
            self.userLocationCoordinate = userLocation.coordinate
            let region  = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            parent.mapView.setRegion(region, animated: true)
        }
        
        // to drow line between two route
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        //MARK: - Helpers - show annotition on map
        
        func addAndSelectAnnotation(setCoordinate coordinate:CLLocationCoordinate2D){
            parent.mapView.removeAnnotations(parent.mapView.annotations)// to remove old annotition
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true) // to move camera map view to new annotition
        }
        
        func configurePloyline(setDestinationCoordinate coordinate:CLLocationCoordinate2D)  {
            guard let userLocationCoordinate = self.userLocationCoordinate else {return}
            
            getDistinationRoute(from: userLocationCoordinate, to: coordinate){ route in
                print("Rounte \(route.polyline)")
                self.parent.mapView.addOverlay(route.polyline)
                
            }
        }
        
        func getDistinationRoute(from userLocation :CLLocationCoordinate2D ,to destinationCoordinate : CLLocationCoordinate2D,
                                 completion: @escaping(/*here you can pase your data*/MKRoute)-> Void){
            
            let userPlacemark = MKPlacemark(coordinate: userLocation)
            let destPlacemark = MKPlacemark(coordinate: destinationCoordinate)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destPlacemark)
            let directions = MKDirections(request: request)
            directions.calculate {respons,error in
                if let error = error{
                    print("Faild to get direction with error\(error.localizedDescription)")
                    return
                }
                guard let route = respons?.routes.first else {return}
                completion(route)
            }
            
        }
        
    }
}

