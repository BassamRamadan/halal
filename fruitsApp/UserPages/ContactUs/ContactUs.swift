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
class ContactUs: common ,CLLocationManagerDelegate{

    var Contacts : ContactsData?
    @IBOutlet var phone: UILabel!
    @IBOutlet var whatsapp: UILabel!
    @IBOutlet var address: UILabel!
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
    var long:Double?
    var lat:Double?
    @IBAction func WhatsButton(sender: UIButton){
        common.callWhats(whats: whatsapp.text ?? "",currentController: self)
    }
    @IBAction func PhoneButton(sender: UIButton){
        CallPhone(phone: phone.text ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButtonWithDismiss()
        getContacts()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCartButton(number: AppDelegate.CartItems.count)
    }
    func setupData(){
        address.text = Contacts?.address ?? ""
        whatsapp.text = Contacts?.whatsapp ?? ""
        phone.text = Contacts?.phone ?? ""
        long = Double(Contacts?.lon ?? "0.0")
        lat = Double(Contacts?.lat ?? "0.0")
    
        let camera = GMSCameraPosition.camera(withLatitude: lat ?? 21.555940, longitude: long ?? 39.194628, zoom: 12.0)
        mapView.camera = camera
        showMarker(position: camera.target)
        self.stopAnimating()
    }
    func getContacts(){
        loading()
        let url = AppDelegate.url+"contactus/\(CashedData.getUserCityId() ?? 0)"
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
        
        marker.position = position
        marker.title = self.address.text
        marker.map = mapView
    }
}
extension ContactUs: GMSMapViewDelegate{
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
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
            guard error == nil else {
                return
            }
            let marker = GMSMarker()
            marker.position = cameraPosition.target
            marker.title = self.address.text
            marker.map = mapView
        }
    }
}
