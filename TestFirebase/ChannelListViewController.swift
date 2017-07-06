//
//  ChannelListViewController.swift
//  TestFirebase
//
//  Created by Eeposit 01 on 7/6/17.
//  Copyright © 2017 Eeposit 01. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

enum Section: Int {
  case createNewChannelSection = 0
  case currentChannelsSection
}

class ChannelListViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  var senderDisplayName: String? 
  var newChannelTextField: UITextField?
  var channels: [Chanel] = []
  private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
  private var channelRefHandle: DatabaseHandle?
  
    override func viewDidLoad() {
        super.viewDidLoad()
       self.tableView.dataSource = self
       self.tableView.delegate = self
       observeChannels()
      // Do any additional setup after loading the view.
    }
  
  deinit {
    if let refHandle = channelRefHandle {
      channelRef.removeObserver(withHandle: refHandle)
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)

  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
  
  private func observeChannels() {
    // Use the observe method to listen for new
    // channels being written to the Firebase DB

    channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
      let channelData = snapshot.value as! Dictionary<String, AnyObject> // 2
      let id = snapshot.key
      if let name = channelData["name"] as! String!, name.characters.count > 0 { // 3
        self.channels.append(Chanel(id: id, name: name))
        self.tableView.reloadData()
      } else {
        print("Error! Could not decode channel data")
      }
    })
  }
  
  @IBAction func createChannel(_ sender: Any) {
    if let name = newChannelTextField?.text {
      let newChannelRef = channelRef.childByAutoId()
      let channelItem = [
        "name": name
      ]
      newChannelRef.setValue(channelItem)
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if let channel = sender as? Chanel {
      let chatVc = segue.destination as! ChatViewController
      
      chatVc.senderDisplayName = senderDisplayName
      chatVc.channel = channel
      chatVc.channelRef = channelRef.child(channel.id!)
    }
  }
}
extension ChannelListViewController: UITableViewDataSource , UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // 2
    if let currentSection: Section = Section(rawValue: section) {
      switch currentSection {
      case .createNewChannelSection:
        return 1
      case .currentChannelsSection:
        return channels.count
      }
    } else {
      return 0
    }
  }
  

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    
    if (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue {
      if let createNewChannelCell = cell as? CreateTableViewCell {
        newChannelTextField = createNewChannelCell.newChannelNameField
      }
    } else if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
      cell.textLabel?.text = channels[(indexPath as NSIndexPath).row].name
    }
    
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == Section.currentChannelsSection.rawValue {
      let channel = channels[(indexPath as NSIndexPath).row]
      self.performSegue(withIdentifier: "ShowChannel", sender: channel)
    }
  }


}
