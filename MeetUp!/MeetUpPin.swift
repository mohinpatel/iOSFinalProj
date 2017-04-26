//
//  MeetUpPin.swift
//  MeetUp!
//
//  Created by Mohin Patel on 4/21/17.
//  Copyright © 2017 Mohin Patel. All rights reserved.
//

import UIKit
import MapKit
class MeetUpPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    let color = UIColor.green
    init(userLocation: CLLocationCoordinate2D, userName: String) {
        title = userName
        coordinate = userLocation
        super.init()
    }
    func getTitle() -> String {
        return self.title!
    }
    func getLocation() -> CLLocationCoordinate2D {
        return coordinate
    }
}
