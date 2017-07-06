//
//  ViewController.swift
//  TestFirebase
//
//  Created by Eeposit 01 on 7/6/17.
//  Copyright © 2017 Eeposit 01. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

  @IBOutlet weak var txtUserName: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func login(_ sender: Any) {
    if self.txtUserName.text != "" {
      Auth.auth().signInAnonymously(completion: { (user, error) in // 2
        if let err = error { // 3
          print(err.localizedDescription)
          return
        }
        self.performSegue(withIdentifier: "LoginToChat", sender: nil) // 4
      })
    }
    
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    let navVc = segue.destination as! UINavigationController // 1
    let channelVc = navVc.viewControllers.first as! ChannelListViewController // 2
    
    channelVc.senderDisplayName = txtUserName?.text // 3
  }
}

