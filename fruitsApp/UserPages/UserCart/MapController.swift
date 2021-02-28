//
//  MapController.swift
//  fruitsApp
//
//  Created by Bassam on 2/23/21.
//  Copyright © 2021 Bassam Ramadan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class MapController: common , CLLocationManagerDelegate{
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var Link: common?
    let geocoder = GMSGeocoder()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    let marker = GMSMarker()
    // The currently selected place.
    var selectedPlace: GMSPlace?
    var position = CLLocationCoordinate2D(latitude: 24.662499, longitude: 46.676857)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        locationManager.delegate = self
        // add button to current location
        self.locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 20)
        marker.isDraggable = true;
        
    }
    @IBAction func acceptLocation(){
        if let parent = Link as? CompletOrder{
            parent.addressOnMap.text = self.address.text
            parent.position = self.position
            self.dismiss(animated: true)
        }
    }
    
}
extension MapController{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        showMarker(position: userLocation!.coordinate)
        self.locationManager.stopUpdatingLocation()
    }
   
    
    func showMarker(position: CLLocationCoordinate2D){
        self.position.latitude = position.latitude
        self.position.longitude = position.longitude
        geocoder.reverseGeocodeCoordinate(position) {
            (response, error) in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self.marker.position = position
            self.marker.title = lines.joined(separator: "\n")
            self.marker.map = self.mapView
            self.address.text = lines.joined(separator: "\n")
        }
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 12.0)
    }
    
    @IBAction func gpsAction(_ sender: Any){
        self.mapView.isMyLocationEnabled = true
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1.0
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied , .restricted , .authorizedAlways:
            print("denied")
        @unknown default:
            print("default")
        }
    }
}
extension MapController: GMSMapViewDelegate{
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
         mapView.clear()
        self.showMarker(position: marker.position)
    }
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        self.showMarker(position: coordinate)
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        self.showMarker(position: coordinate)
    }
}
