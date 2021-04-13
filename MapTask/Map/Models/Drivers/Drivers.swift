//
//  Drivers.swift
//  MapTask
//
//  Created by Salah  on 4/13/21.
//

import Foundation
import Firebase
import CoreLocation

class Driver{

    var name = ""
    var latitude = 0.0
    var longitude = 0.0
    var location:CLLocation


    init(data:QueryDocumentSnapshot) {
        name = data["name"] as? String ?? ""
        latitude = data["latitude"] as? CLLocationDegrees ?? 0.0
        longitude = data["longitude"] as? CLLocationDegrees ?? 0.0
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
}
