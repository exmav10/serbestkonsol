//
//  liste.swift
//  SerbestKonsol
//
//  Created by Aydın ÜNAL on 17.02.2017.
//  Copyright © 2017 Aydın ÜNAL. All rights reserved.
//

import UIKit
import Firebase
class liste: UITableViewController {
    
    var telNos = [String]()
    var uids = [String]()
    var selectedUid = String()
    var selectedTelno = String()
    var ref = FIRDatabaseReference.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        ref = FIRDatabase.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        loadUid()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return uids.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? Cell
        var telno = telNos[indexPath.row]
        var uid = uids[indexPath.row]
        cell?.cellFunc(telefonNo: telno)
        
        // Configure the cell...
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(uids[indexPath.row])
        selectedUid = uids[indexPath.row]
        selectedTelno = telNos[indexPath.row]
        self.performSegue(withIdentifier: "listeToViewController", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "listeToViewController"){
            if let destination = segue.destination as? ViewController {
                destination.uid = selectedUid
                destination.telno = selectedTelno
            }
            
        }
    }
    func loadUid(){
        self.uids = []
        self.telNos = []
        ref.child("application").observe(.value, with: {
            snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    var key1 = snap.key
                    self.ref.child("application").child(snap.key).child("userApp").observe(.value, with: {
                        snapshot in
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                            for snap in snapshots{
                                var key2 = snap.key
                                self.ref.child("application").child(key1).child("userApp").child(key2).child("image").observe(.value, with: {
                                    snapshot in
                                    if snapshot.value as? String == "used" {
                                        self.ref.child("application").child(key1).child("userApp").child(key2).child("Phone").observe(.value, with: {
                                            snapshot in
                                            self.uids.append(key1)
                                            self.telNos.append(snapshot.value as! String)
                                            self.tableView.reloadData()
                                        })
                                    }
                                })
                            }
                        }
                    })
                }
            }
        })
    }
}
