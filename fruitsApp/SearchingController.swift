//
//  SearchingController.swift
//  B.Station_IOS
//
//  Created by Bassam Ramadan on 1/18/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import DropDown

class LaunchController: common {

    let CityDrop = DropDown()
    let RegionDrop = DropDown()
 
    
    var CitiesObjects = [Details]()
    var RegionsObjects = [Details]()
    
    
    var CityId : Int! = nil
    var RegionId : Int! = nil
    
    @IBOutlet weak var CityButton: UIButton!
    @IBOutlet weak var RegionButton: UIButton!
    
    
    @IBAction func Submit(_ sender: Any) {
       //     self.loadingCompanies()
    }
   
    @IBAction func CityClick(_ sender: UIButton) {
        CityDrop.anchorView = (sender as AnchorView)
        CityDrop.dataSource = parsingData(self.CitiesObjects)
        CityDrop.bottomOffset = CGPoint(x: 0, y:(CityDrop.anchorView?.plainView.bounds.height)!)
        CityDrop.selectionAction = {
            [unowned self](index : Int , item : String)in
                self.CityButton.setTitle(item, for: .normal)
                self.CityId = self.CitiesObjects[index].id
            }
        CityDrop.show()
    }
    @IBAction func RegionClick(_ sender: UIButton) {
        ResetPoints()
        RegionDrop.anchorView = (sender as AnchorView)
        RegionDrop.dataSource = parsingData(self.RegionsObjects)
        RegionDrop.bottomOffset = CGPoint(x: 0, y:(RegionDrop.anchorView?.plainView.bounds.height)!)
        RegionDrop.selectionAction = {
            [unowned self](index : Int , item : String)in
            self.RegionButton.setTitle(item, for: .normal)
            self.RegionId = self.RegionsObjects[index].id
            self.getCities()
        }
        RegionDrop.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRegions()
    }
    
    fileprivate func ResetPoints(){
        self.CityId = nil
        self.CitiesObjects.removeAll()
        self.CityButton.setTitle("المدينة", for: .normal)
    }
    fileprivate func parsingData(_ data : [Details])->[String]{
        var ResData = [String]()
        for x in data {
            ResData.append(x.name ?? "")
        }
        return ResData
    }
    
    
    
    func getRegions(){
        loading()
        let url = "https://halal-app.com/azhelha/public/api/areas"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json"
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(City.self, from: jsonData)
                if error == nil{
                    if success{
                         self.RegionsObjects.removeAll()
                        self.RegionsObjects.append(contentsOf: dataRecived.data)
                        self.stopAnimating()
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
    
    
    func getCities(){
        loading()
        let url = "https://halal-app.com/azhelha/public/api/cities/\(self.RegionId ?? 0)"
        let headers = [
            "Accept" : "application/json",
            "Content-Type": "application/json"
        ]
        AlamofireRequests.getMethod(url: url, headers:headers) { (error, success , jsonData) in
            do {
                let decoder = JSONDecoder()
                let dataRecived = try decoder.decode(City.self, from: jsonData)
                if error == nil{
                    if success{
                        
                        self.CitiesObjects.append(contentsOf: dataRecived.data)
                        self.stopAnimating()
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
}
