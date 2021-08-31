//
//  MapPickedGMSMapViewDelegate.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import UIKit
import GoogleMaps
import CoreLocation

extension MapPickedViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        // Delete All Markers:-
        mappickedviewmodel.mapView?.clear()
        
        // For Pick one Location Use this Method:-
        SetOneLocation(coordinate: coordinate)
        
        mappickedviewmodel.longBehaviour.accept(coordinate.longitude)
        mappickedviewmodel.latiBehaviour.accept(coordinate.latitude)
    }
    
    func SetOneLocation (coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.title = mappickedviewmodel.ShopNameBehaviour.value
        marker.map = mappickedviewmodel.mapView

        mappickedviewmodel.mapView?.frame = MapView.bounds
        mappickedviewmodel.mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        // remove old map
        mappickedviewmodel.mapView!.removeFromSuperview()
        //add new map
        MapView.addSubview(mappickedviewmodel.mapView!)
    }
    
}

extension MapPickedViewController: CLLocationManagerDelegate {
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let l = locations[locations.count - 1]
        if l.horizontalAccuracy > 0 {
            location.stopUpdatingLocation()
            location.delegate = nil
            
            print("Long = \(l.coordinate.longitude) latitude = \(l.coordinate.latitude)")
            
            mappickedviewmodel.SetGoogleMapsOperation(lati: l.coordinate.latitude, long: l.coordinate.longitude, view: MapView, zoom: 15, delegate: self)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
