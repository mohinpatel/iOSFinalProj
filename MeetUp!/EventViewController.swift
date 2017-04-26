//
//  EventViewController.swift
//  MeetUp!
//
//  Created by Mohin Patel on 4/17/17.
//  Copyright © 2017 Mohin Patel. All rights reserved.
//

import UIKit
import Firebase
class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var background: UIImageView!
    var events: [EventModel] = []
    @IBOutlet weak var tableView: UITableView!
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var username: String?
    var eventSelected: EventModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        
        tableView.backgroundColor = UIColor.clear
        
        // Do any additional setup after loading the view.
        ref.child(firEvent).observeSingleEvent(of: .value, with: {
            snapshot in
            let allEvents = snapshot.value as! [String: Any]
            for (autoID, dictionary) in allEvents {
                var userInvited: Bool = false
                var eventName = ""
                var invited: [String] = []
                let dict1 = dictionary as! [String: Any]
                for (name, value) in dict1 {
                    if name == firEventName {
                        eventName = value as! String
                    } else if name == firInvited {
                        let temp = value as! [String]
                        for (invitee) in temp {
                            if invitee == self.username {
                                userInvited = true
                            }
                            invited += [invitee]
                        }
                    }
                    
                }
                if userInvited  {
                    let event = EventModel(name: eventName, users:  invited, autoID: autoID)
                    self.events = [event] + self.events
                }
            }
            self.tableView.reloadData()
            
        })
        if username == nil {
            self.username = FIRAuth.auth()?.currentUser?.displayName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        let event = events[indexPath.row]
        cell.title.text = event.name
        cell.friends.text = "Invited: " + event.users.joined(separator: ", ")
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        if !event.noEvents {
            self.eventSelected = event
            self.performSegue(withIdentifier: "toMap", sender: nil)
        }
        
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    @IBAction func unwindToMenuFromMap(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toMap" {
                if let dest = segue.destination as? MapViewController {
                    dest.event = self.eventSelected
                }
            }
        }
    }
    @IBAction func createEvent(_ sender: LoginButton) {
        self.performSegue(withIdentifier: "makeEvent", sender: nil)
        
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
