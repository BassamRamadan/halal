//
//  ContactUs.swift
//  ezhelhaa
//
//  Created by Bassam Ramadan on 3/28/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class AddContactUs: common ,CLLocationManagerDelegate{
    
    var Contacts : ContactsData?
    @IBOutlet var phone: UITextField!
    @IBOutlet var whatsapp: UITextField!
    @IBOutlet var address: UITextField!
    let geocoder = GMSGeocoder()
    @IBOutlet var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    let marker = GMSMarker()
    // The currently selected place.
    var selectedPlace: GMSPlace?
    var long:CLLocationDegrees?
    var lat:CLLocationDegrees?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        showMarker(position: userLocation!.coordinate)
        self.locationManager.stopUpdatingLocation()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "إضافة وسائل الإتصال"
        setupBackButtonWithDismiss()
        getContacts()
    }
    
  
    func setupData(){
        address.text = Contacts?.address ?? ""
        whatsapp.text = Contacts?.whatsapp ?? ""
        phone.text = Contacts?.phone ?? ""
        long = Double(Contacts?.lon ?? "0.0")
        lat = Double(Contacts?.lat ?? "0.0")
        mapView.delegate = self
        let camera = GMSCameraPosition.camera(withLatitude: lat ?? 21.555940, longitude: long ?? 39.194628, zoom: 12.0)
        mapView.camera = camera
        showMarker(position: camera.target)
        self.stopAnimating()
    }
    @IBAction func Save(sender: UIButton){
        let  url = AppDelegate.url+"add-contact"
        let headers = [ "Content-Type": "application/json" ,
                        "Accept" : "application/json",
                        "Authorization": "Bearer " + (CashedData.getAdminApiKey() ?? "")
        ]
        let info:[String : Any] = [
            "lat": "\(self.lat ?? 0.0)",
            "lon": "\(self.long ?? 0.0)",
            "address": self.address.text ?? "",
            "phone": self.phone.text ?? "",
            "whatsapp": self.whatsapp.text ?? ""
        ]
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: info, headers: headers){
            (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                if error == nil{
                    if success{
                        self.present(common.makeAlert(message: "تم الإضافة بنجاح"), animated: true, completion: nil)
                        self.stopAnimating()
                    }else{
                        self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                        self.stopAnimating()
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            }catch {
                self.present(common.makeAlert(message: error.localizedDescription), animated: true, completion: nil)
            }
        }
    }
    
    func getContacts(){
        loading()
        let url = AppDelegate.url+"contactus/\(CashedData.getAdminCityId() ?? "")"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json"
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(AppContacts.self, from: jsonData)
                if error == nil{
                    if success{
                        self.Contacts = dataRecived.data
                        self.setupData()
                    }
                    else  {
                        self.present(common.makeAlert(message: dataRecived.message ?? "" ), animated: true, completion: nil)
                        self.stopAnimating()
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            } catch {
                self.present(common.makeAlert(message: "حدث خطأ بالرجاء التاكد من تسجيل الدخول "), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
    }
    func showMarker(position: CLLocationCoordinate2D){
        
        self.long = position.longitude
        self.lat = position.latitude
        geocoder.accessibilityLanguage = "ar"
        geocoder.reverseGeocodeCoordinate(position) { (response, error) in
            
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self.marker.position = position
            self.marker.title = lines.joined(separator: "\n")
            self.marker.map = self.mapView
            self.address.text = lines.joined(separator: "\n")
        }
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
extension AddContactUs: GMSMapViewDelegate{
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        print("didDrag")
     
        self.showMarker(position: coordinate)
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        mapView.clear()
    }
    
    
}
