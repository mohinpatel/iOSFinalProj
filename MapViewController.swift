//
//  MapViewController.swift
//  MeetUp!
//
//  Created by Mohin Patel on 4/13/17.
//  Copyright © 2017 Mohin Patel. All rights reserved.
//

import UIKit
import MapKit
import Firebase
class MapViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var userTable: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    var pins: [UsersPin] = []
    let radius: CLLocationDistance = 1000
    
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    let manager = CLLocationManager()
    var userLocation: CLLocation?
    
    var usersCheckedIn: [String] = []
    var event: EventModel?
    
    var userKey: String?
    var username: String = (FIRAuth.auth()?.currentUser?.displayName!)!
    var userPin: UsersPin?
    var meetUp: UsersPin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        map.delegate = self
        
        userTable.backgroundColor = UIColor.clear
        
        let longPressRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressRecogniser.numberOfTapsRequired = 1
        map.addGestureRecognizer(longPressRecogniser)
        if !CLLocationManager.locationServicesEnabled(){
            manager.requestWhenInUseAuthorization()
        }
        manager.startUpdatingLocation()
        //TableView
        userTable.delegate = self
        userTable.dataSource = self
        usersCheckedIn = self.usersWithPins()
        //FireBase Retrive Pins
        let reference = ref.child(firEvent).child(event!.autoID).child(firPins)
        reference.observeSingleEvent(of: .value, with: {
            snapshot  in
            let pins = snapshot.value as? [String: Any]
            var allPins: [UsersPin] = []
            for (key, value) in pins! {
                if key == "empty" {
                    continue
                } else {
                    let dict = value as! [String: Any]
                    var lat = 0.0
                    var long = 0.0
                    var username = ""
                    var thisMe = false
                    for (key1, value1) in dict {
                        switch (key1) {
                        case firLat:
                            lat = value1 as! Double
                        case firLongitude:
                            long = value1 as! Double
                        case firUserName:
                            if self.username == value1 as! String {
                                self.userKey = key
                                thisMe = true
                            }
                            username = value1 as! String
                            self.usersCheckedIn += [username]
                        default:
                            continue;
                        }
                        
                    }
                    
                    let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let pin = UsersPin(userLocation: location, userName: username, identifier: "User")
                    if thisMe {
                        self.userPin = pin
                    }
                    else {
                      allPins += [pin]
                    }
                }
                
            }
            self.pins = allPins
            // if current user has pin let it be used to calculate centroid.
            if let pin = self.userPin {
                allPins += [pin]
            }
            if allPins.count > 0 {
                self.map.addAnnotations(allPins)
                //centroid
                let centroid = self.event!.centroid(pins: allPins)
                self.meetUp = UsersPin(userLocation: centroid, userName: "MeetUp!", identifier: "MeetUp!")
                self.map.addAnnotation(self.meetUp!)
            }
            self.userTable.reloadData()
        })
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let location = userLocation {
            centerMap(location: location)
        }
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - CLLocation Manager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[locations.count - 1]
        manager.stopUpdatingLocation()
    }
    //MARK: -TapGestureSelector
    func handleLongPress(_ sender: UITapGestureRecognizer) {
        var reloadTable = false
        if sender.state != .ended {
            print("hi")
            return
        }
        if let usersPin = self.userPin {
            map.removeAnnotation(usersPin)
            self.userPin = nil
        } else {
            self.usersCheckedIn += [self.username]
        }
        if let meet = self.meetUp {
            map.removeAnnotation(meet)
            reloadTable = true
        }
        let touchLocation = sender.location(in: map)
        let touchCoordinate = map.convert(touchLocation, toCoordinateFrom: map)
        let pin = UsersPin(userLocation: touchCoordinate, userName: self.username, identifier: "User")
        let firPin: [String: Any] = [
            "Latitude": touchCoordinate.latitude,
            "Longitude": touchCoordinate.longitude,
            firUserName: self.username]
        
        map.addAnnotation(pin)
        self.userPin = pin
        if let key = self.userKey {
            let reference1 =  ref.child(firEvent).child((event?.autoID)!).child(firPins).child(key)
            reference1.updateChildValues(firPin)
            
        } else {
            let reference2 = ref.child(firEvent).child(event!.autoID).child(firPins).childByAutoId()
            self.userKey = reference2.key
            reference2.setValue(firPin)
        }
        let allPins = self.pins + [self.userPin!]

        self.meetUp = UsersPin(userLocation: event!.centroid(pins: allPins), userName: "MeetUp!", identifier: "MeetUp!")
        map.addAnnotation(self.meetUp!)
        if reloadTable {
            self.userTable.reloadData()
        }
    
    }
    func centerMap(location: CLLocation) {
        let mapRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius*2, radius*2)
        map.setRegion(mapRegion, animated: true)
    }
    
    //MARK: -TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let event = self.event {
            return event.users.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTable.dequeueReusableCell(withIdentifier: "userClickedIn", for: indexPath) as! MapCell
        let user = self.event?.users[indexPath.row]
        cell.userLabel.text = user
        if usersCheckedIn.contains(user!) {
            cell.userTapped.isHidden = false
            cell.userTapped.image = UIImage(named: "checkmark")
        } else {
            cell.userTapped.isHidden = true
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func usersWithPins() -> [String] {
        var usersClickedIn: [String] = []
        for pin in self.pins {
            usersClickedIn.append(pin.title!)
        }
        return usersClickedIn
    }
    @IBAction func goBackToEvent(_ sender: UIButton) {
        self.performSegue(withIdentifier: "cancelFromMap", sender: nil)
    }
    // MARK: -Map delegate Methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? UsersPin {
            let identifier = annotation.identifier
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                
                if annotation.identifier == "User" {
                    view.pinTintColor = MKPinAnnotationView.purplePinColor()
                    
                } else {
                    view.pinTintColor = MKPinAnnotationView.redPinColor()
                }
            return view
            }
        }
        return nil
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
