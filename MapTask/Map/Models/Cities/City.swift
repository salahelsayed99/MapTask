//
//  City.swift
//  MapTask
//
//  Created by Salah  on 4/13/21.
//

import Foundation
import CoreLocation
import Firebase

class City{

    var name = ""
    var latitude = 0.0
    var longitude = 0.0



    
    init(data:QueryDocumentSnapshot) {
        name = data["name"] as? String ?? ""
        latitude = data["latitude"] as? CLLocationDegrees ?? 0.0
        longitude = data["longitude"] as? CLLocationDegrees ?? 0.0
        
    }
}
