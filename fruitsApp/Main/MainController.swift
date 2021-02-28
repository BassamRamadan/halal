//
//  SearchingController.swift
//  B.Station_IOS
//
//  Created by Bassam Ramadan on 1/18/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import DropDown

class MainController: common {
    var CitiesObjects = [Details]()
    var RegionsObjects = [Details]()
    
    @IBOutlet weak var CityCollection: UICollectionView!
    @IBOutlet weak var RegionCollection: UICollectionView!
    @IBOutlet weak var AdminLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegation()
        self.getRegions(){ (data : [Details]) in
            self.RegionsObjects.removeAll()
            self.RegionsObjects.append(contentsOf: data)
            if data.count > 0{
                self.getCities(RegionId: data[0].id ?? 0)
            }
            self.RegionCollection.reloadData()
        }
        line.removeFromSuperview()
    }
    
    fileprivate func setDelegation(){
        RegionCollection.delegate = self
        RegionCollection.dataSource = self
        CityCollection.delegate = self
        CityCollection.dataSource = self
    }
    
    fileprivate func getCities(RegionId: Int) {
        self.getCities(RegionId: RegionId) { (data) in
            self.CitiesObjects.removeAll()
            self.CitiesObjects.append(contentsOf: data)
            self.CityCollection.reloadData()
        }
    }
    @IBAction func showAdminLogin(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.7, options: .curveEaseIn) {
            self.AdminLogin.isHidden = !self.AdminLogin.isHidden
        }
    }
    func Submit() {
        let storyboard = UIStoryboard(name: "UserPages", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "UserPagesTaB") as! UserPagesController
        linkingVC.selectedIndex = 0
        linkingVC.modalPresentationStyle = .fullScreen
        self.present(linkingVC, animated: true)
    }
}
extension MainController: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == RegionCollection{
            return self.RegionsObjects.count
        }else{
            return self.CitiesObjects.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == RegionCollection{
            return CGSize(width: calcTextWidth(RegionsObjects[indexPath.row].name ?? "")+60, height: 50)
        }else{
            return CGSize(width: calcTextWidth(CitiesObjects[indexPath.row].name ?? "")+30, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == RegionCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegionCell", for: indexPath) as! RegionCell
            cell.name.text = RegionsObjects[indexPath.row].name ?? ""
            if RegionsObjects[indexPath.row].id == CashedData.getUserRegionId(){
                clearBorder(cell)
            }else{
                setBorder(cell)
            }
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as! RegionCell
            cell.name.text = CitiesObjects[indexPath.row].name ?? ""
            if indexPath.row + 1 != CitiesObjects.count {
                cell.name.text = "|   \(CitiesObjects[indexPath.row].name ?? "")"
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView == RegionCollection) ? 10 : 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == RegionCollection{
            CashedData.saveUserRegionId(name: RegionsObjects[indexPath.row].id ?? 0)
            CashedData.saveUserRegionName(name: RegionsObjects[indexPath.row].name ?? "")
            RegionCollection.reloadData()
            self.getCities(RegionId: RegionsObjects[indexPath.row].id ?? 0)
        }else{
            CashedData.saveUserCityId(name: CitiesObjects[indexPath.row].id ?? 0)
            CashedData.saveUserCityName(name: CitiesObjects[indexPath.row].name ?? "")
            Submit()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var totalSpacingWidth: CGFloat = 0
        var totalCellWidth: CGFloat = 0
        if collectionView == RegionCollection{
            if RegionsObjects.count <= 5{
                RegionsObjects.forEach { (row) in
                    totalCellWidth += calcTextWidth(row.name ?? "")+60
                }
                totalSpacingWidth = CGFloat(10 * (RegionsObjects.count))
            }
        }else{
            if CitiesObjects.count <= 5{
                CitiesObjects.forEach { (row) in
                    totalCellWidth += calcTextWidth(row.name ?? "")+30
                }
            }
        }
        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        return UIEdgeInsets(top: 0, left: max(leftInset,0), bottom: 0, right: max(leftInset,0))
    }
    fileprivate func calcTextWidth(_ text: String)-> CGFloat{
        let label = UILabel(frame: CGRect.zero)
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
    fileprivate func setBorder(_ cell: RegionCell) {
        cell.contentView.backgroundColor = .clear
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.borderWidth = 1.5
        cell.contentView.layer.borderColor = UIColor.white.cgColor
    }
    fileprivate func clearBorder(_ cell: RegionCell) {
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.borderWidth = 0
        cell.contentView.backgroundColor = UIColor(named: "placeholder")
        
    }
}
