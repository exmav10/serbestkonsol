//
//  ViewController.swift
//  SerbestKonsol
//
//  Created by Aydın ÜNAL on 17.02.2017.
//  Copyright © 2017 Aydın ÜNAL. All rights reserved.
//

import UIKit
import FirebaseStorageUI
import Firebase
import SDWebImage
class ViewController: UIViewController {
    var uid = String()
    var telno = String()
    @IBOutlet weak var isim: UILabel!
    @IBOutlet weak var soyad: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var telefon: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var ref = FIRDatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(withPath: "faturalar").child(uid).child(telno)
        let placeholderImage = UIImage(named: "foto.png")
        imageView.sd_setImage(with: storageRef, placeholderImage: nil, completion: {
            (image, error, cacheType, storageRef) in
            print("hi")
        })
        loadData()
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData(){
        self.ref.child("application").child(uid).child("userApp").observe(.value, with: {
            snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    var key = snap.key
                    self.ref.child("application").child(self.uid).child("userApp").child(key).child("First Name").observe(.value, with: {
                        snapshot in
                            self.isim.text = snapshot.value as? String
                    })
                    self.ref.child("application").child(self.uid).child("userApp").child(key).child("Last Name").observe(.value, with: {
                        snapshot in
                        self.soyad.text = snapshot.value as? String
                    })
                    self.ref.child("application").child(self.uid).child("userApp").child(key).child("Phone").observe(.value, with: {
                        snapshot in
                        self.telefon.text = snapshot.value as? String
                    })
                    self.ref.child("application").child(self.uid).child("userApp").child(key).child("Email").observe(.value, with: {
                        snapshot in
                        self.email.text = snapshot.value as? String
                    })
                }
            }
        })
    }
    @IBAction func onayla(){
        self.ref.child("application").child(uid).child("userApp").observe(.value, with: {
            snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    var key = snap.key
                    self.ref.child("application").child(self.uid).child("userApp").child(key).child("image").setValue("checked")
                    self.showAlert()
                }
            }
        })
    }
    func showAlert(){
        let alert = UIAlertController(title: "Tamam", message: "Tamamdır Aydınım", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: {
            action in self.performSegue(withIdentifier: "geriDon", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
