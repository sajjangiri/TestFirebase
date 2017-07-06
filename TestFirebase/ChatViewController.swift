//
//  ChatViewController.swift
//  TestFirebase
//
//  Created by Eeposit 01 on 7/6/17.
//  Copyright © 2017 Eeposit 01. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import JSQMessagesViewController

class ChatViewController:JSQMessagesViewController {
  var channelRef: DatabaseReference?
  var channel: Chanel? {
    didSet {
      title = channel?.name
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
