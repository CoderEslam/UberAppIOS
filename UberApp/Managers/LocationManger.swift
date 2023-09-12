//
//  LocationManger.swift
//  UberApp
//
//  Created by Eslam Ghazy on 19/8/23.
//

import SwiftUI
import CoreLocation


class LocationManger :NSObject , ObservableObject {
    
    private let locationManger = CLLocationManager()
    
    
    override init() {
        super.init()
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
    }
}


extension LocationManger : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else {return}
        locationManger.stopUpdatingLocation()
    }
}
