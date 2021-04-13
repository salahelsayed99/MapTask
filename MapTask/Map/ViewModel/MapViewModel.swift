//
//  MapViewModel.swift
//  MapTask
//
//  Created by Salah  on 4/13/21.
//

import Foundation
import Firebase
import CoreLocation

struct Constants {
    static let sourceCollectionName = "Source"
    static let driversCollectionName = "Drivers"
    static let cityCellIdentifier = "cityCell"
    static let sideMenuCellIdentifier = "defaultCell"
    static let errorMessage = "Sorry we can't retrieve the data"
}


protocol MapViewModelDelegate {
    func onError(error:String)
    func onCities(_ data:[City])
}


class MapViewModel {
    
    var drivers = [Driver]()
    var driversLocations = [CLLocation]()
    var delegate:MapViewModelDelegate?
    
    let db = Firestore.firestore()
    
    public func requestData(){
        fetchCities()
        fetchDrivers()
    }
    
    
    private func fetchCities(){
        ThreadsUtility.execute({
            self.db.collection(Constants.sourceCollectionName).getDocuments { (data, error) in
                if error != nil{
                    self.delegate?.onError(error: Constants.errorMessage)
                }else{
                    if let doc = data?.documents{
                        let cities = doc.map { City(data: $0)}
                        self.delegate?.onCities(cities)
                    }
                }
            }
            
        }, afterDelay: 0.0)
    }
    
    private func fetchDrivers(){
        ThreadsUtility.execute({
            self.db.collection(Constants.driversCollectionName).getDocuments { (data, error) in
                if error != nil{
                    self.delegate?.onError(error: Constants.errorMessage)
                }else{
                    if let doc = data?.documents{
                        self.drivers = doc.map { Driver(data: $0)}
                        self.driversLocations = self.drivers.map({ (driver) in
                            return driver.location
                        })
                    }
                    
                }
            }
            
        }, afterDelay: 0.0)
    }
    
    
    public func findClosestDriver(userLocation:CLLocation?)->String{
        if let userCurrentLocation = userLocation{
            let closest = driversLocations.min(by:{ $0.distance(from: userCurrentLocation)
                                                < $1.distance(from: userCurrentLocation) })
            
            for loc in drivers{
                if loc.location.isEqual(closest){
                    return loc.name
                }
                
            }
            
        }
        return ""
    }
    
    
}
