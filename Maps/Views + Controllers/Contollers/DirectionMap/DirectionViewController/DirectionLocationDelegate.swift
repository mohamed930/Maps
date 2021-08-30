//
//  DirectionLocationDelegate.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import UIKit
import CoreLocation
import MapKit

extension DirectionViewController: CLLocationManagerDelegate {
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let l = locations[locations.count - 1]
        if l.horizontalAccuracy > 0 {
            location.stopUpdatingLocation()
            location.delegate = nil
            
            print("Long = \(l.coordinate.longitude) latitude = \(l.coordinate.latitude)")
            
            directionviewmodel.currentlati.accept(l.coordinate.longitude)
            directionviewmodel.currentlong.accept(l.coordinate.longitude)
            
            if directionviewmodel.PickedShopNamed.value != "" {
                
                // MAKE Any thing with cordinates.
                self.directionviewmodel.AddAnotationOperation(mapview: MapKit) { [weak self] isDrawed in
                    
                    guard let self = self else { return }
                    
                    if isDrawed {
                        self.MapKit.removeOverlays(self.MapKit.overlays)
                        self.DrawLine(sourcelati: l.coordinate.latitude, sourcelong: l.coordinate.longitude)
                    }
                }
                
                
                
            }
            else {
                directionviewmodel.SetMapConfigureOperation(mapView: MapKit, lati: l.coordinate.latitude, long: l.coordinate.longitude)
            }
            
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func DrawLine(sourcelati: Double , sourcelong: Double) {
        
        let sourcePlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: sourcelati, longitude: sourcelong))
        
        if directionviewmodel.currentlati.value != 0.0 && directionviewmodel.currentlong.value != 0.0 {
            
            let destinationPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: directionviewmodel.currentlati.value, longitude: directionviewmodel.currentlong.value))
            
                let directionRequest = MKDirections.Request()
                directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
                directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
                directionRequest.transportType = .automobile
               
                let direction = MKDirections(request: directionRequest)
                direction.calculate {  [weak self] (direction, error) in
                    
                    guard let self = self else { return }
                    
                   guard let directionResponse = direction else{
                       if error != nil {
                           print("Error in drawing! \((error?.localizedDescription)!)")
                       }
                       return
                   }
                   
                   let route = directionResponse.routes[0]
                   self.MapKit.addOverlay(route.polyline,level: .aboveRoads)
                   
                   let rect = route.polyline.boundingMapRect
                   
                    self.directionviewmodel.MakeLocation(mapView: self.MapKit, Title: "Your Location", SubTitle: "You Live here", lati: sourcelati, long: sourcelong)
                   self.MapKit.setRegion(MKCoordinateRegion(rect), animated: true)
               }
            
            self.MapKit.delegate = self
            
        }
        else {
            print("No Line")
        }
        
    }
    
}

extension DirectionViewController: MKMapViewDelegate {
    
    // MARK:- mapkit delegates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
}
