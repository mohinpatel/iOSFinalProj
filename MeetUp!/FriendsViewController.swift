//
//  FriendsViewController.swift
//  
//
//  Created by Mohin Patel on 4/17/17.
//
//

import UIKit
import Firebase
class FriendsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var createEvent: LoginButton!
    @IBOutlet weak var eventName: RoundedTextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var searchActive: Bool = false
    var selectionActive: Bool = false
    var users: [String]?
    var filtered: [String] = []
    var selected: [String] = []
    var event: EventModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = background.bounds
        background.addSubview(blurEffectView)
        tableView.backgroundColor = UIColor.clear
        ref.child(firUsers).observe(.value, with: {
            snapshot in
            var allUsers: [String] = []
            let data = snapshot.value as! [String: String]
            for (_ , value) in data {
                allUsers += [value]
            }
            self.users = allUsers
            self.tableView.reloadData()
        })
        createEvent.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = users!.filter({
            (text) -> Bool in
            return text.range(of: searchText) != nil
        })
        if filtered.count == 0 {
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        } else {
            return users?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friend", for: indexPath) as! FriendsCell
        var name = ""
        if searchActive {
            name = filtered[indexPath.row]

        } else {
            name = users![indexPath.row]
        }
        cell.friendName.text = name
        if selected.contains(name) {
            cell.addedFriend.image = UIImage(named: "checkmark")
        } else {
            cell.addedFriend.image = UIImage(named: "PlusIcon_Small_Gray")
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive {
            let elementA = filtered[indexPath.row]
            if selected.contains(elementA) {
                self.selected = selected.filter({ $0 != elementA })
            } else {
            selected += [filtered[indexPath.row]]
            }
        } else {
            let elementB = users![indexPath.row]
            if selected.contains(elementB) {
                self.selected = selected.filter({ $0 != elementB })
            } else {
                selected += [users![indexPath.row]]
            }
        }
        tableView.reloadData()
        if selected.count != 0 && eventName.text != "" {
            createEvent.isHidden = false
        } else {
            createEvent.isHidden = true
        }
    }
    
    @IBAction func makeEvent(_ sender: LoginButton) {
        let name = eventName.text!
    
        let users = self.selected
        //Firebase send event to database
//        let key = ref.child(firEvent).childByAutoId().
//        ref.child(firEvent).child(key)
        let event: [String: Any] = [
        "EventName": name,
        "Invited": users,
        "Pins": ["empty": 0]
        ]
        let reference = ref.child(firEvent).childByAutoId()
        reference.setValue(event)
        self.event = EventModel(name: name, users: users, autoID: reference.key)
        performSegue(withIdentifier: "createdEvent", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "createdEvent" {
                if let destination = segue.destination as? MapViewController {
                    destination.event = self.event
                }
            }
        }
    }
    @IBAction func cancel(_ sender: UIButton) {
        self.performSegue(withIdentifier: "cancel", sender: nil)
    }


}
