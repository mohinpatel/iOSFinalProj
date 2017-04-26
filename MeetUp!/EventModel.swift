//
//  EventModel.swift
//  
//
//  Created by Mohin Patel on 4/18/17.
//
//

import Foundation
import MapKit
class EventModel {
    
    var users: [String]
    
    var name: String
    var locations: [CLLocation]?
    var noEvents: Bool
    var autoID: String
    init(name: String, users: [String], autoID: String) {
        self.users = users
        self.name = name
        self.autoID = autoID
        self.noEvents = false
    }
    init(noEvents: Bool) {
        self.users = []
        self.noEvents = noEvents
        self.name = ""
        self.autoID = ""
    }
    func centroid(pins: [UsersPin]) -> CLLocationCoordinate2D {
        var xLat = 0.0
        var yLong = 0.0
        for pin in pins {
            let location =  pin.coordinate
            let long = location.longitude
            let lat = location.latitude
            xLat += lat as Double
            yLong += long as Double
        }
        xLat = xLat/Double(pins.count)
        yLong = yLong/Double(pins.count)
        return CLLocationCoordinate2D(latitude: xLat, longitude: yLong)
    }
//    func getCentroid() -> CLLocation {
//        // write centroid method over CLlocation array
//        return nil
//    }
//    
}
