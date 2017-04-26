//
//  UsersPin.swift
//  MeetUp!
//
//  Created by Mohin Patel on 4/13/17.
//  Copyright © 2017 Mohin Patel. All rights reserved.
//

import UIKit
import MapKit
class UsersPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    let pinColor = UIColor.red
    var identifier: String
    init(userLocation: CLLocationCoordinate2D, userName: String, identifier: String) {
        title = userName
        coordinate = userLocation
        self.identifier = identifier
        super.init()
    }
    func getTitle() -> String {
        return self.title!
    }
    func getLocation() -> CLLocationCoordinate2D {
        return coordinate
    }
}
