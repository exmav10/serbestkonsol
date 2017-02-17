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
        self.performSegue(withIdentifier: "listeToViewController", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "listeToViewController"){
            if let destination = segue.destination as? ViewController {
                destination.uid = selectedUid
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
