//
//  LocationSearchViewViewModel.swift
//  UberApp
//
//  Created by Eslam Ghazy on 19/8/23.
//

import SwiftUI
import MapKit
//https://github.com/abuanwar072
class LocationSearchViewViewModel:NSObject , ObservableObject {
    
    // MARK - Properties
    
    @Published var resulte = /*this is array*/ [MKLocalSearchCompletion]()
    @Published var selectedLocationCoordinate:CLLocationCoordinate2D?
    private let searchCompleter = MKLocalSearchCompleter()
    @Published var queryFragment : String = "" {
        didSet{
            print("DEBUG : => \(queryFragment)")
            // this to update what user write..
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    
    func selectedLocation(_ location:MKLocalSearchCompletion){
        locationSearch(forLocalSearchCompletion: location) {response ,error in // public typealias CompletionHandler = (MKLocalSearch.Response?, Error?) -> Void
            if let error = error {
                print("Location Search Failed \(error.localizedDescription)")
                // to not compelete excution of code
                return
            }
            guard let item = response?.mapItems.first else {return}
            let coordinate  = item.placemark.coordinate
            self.selectedLocationCoordinate = coordinate

        }
    }
    
    
    func locationSearch(forLocalSearchCompletion localSearch:MKLocalSearchCompletion ,
                        
                        compeltion : @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: compeltion)
    }
    
}


// MARK - MKLocalSearchCompleterDelegate
extension LocationSearchViewViewModel : MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.resulte = completer.results
    }
}
