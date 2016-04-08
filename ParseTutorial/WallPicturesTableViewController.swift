//
//  WallPicturesTableViewController.swift
//  ParseTutorial
//
//  Created by Ron Kliffer on 3/8/15.
//  Copyright (c) 2015 Ron Kliffer. All rights reserved.
//

import UIKit

  var wallPostSelected: WallPost?

class WallPicturesTableViewController: PFQueryTableViewController {
  
  var cellSelected:NSIndexPath?
  var imageSelected: WallPostTableViewCell?

  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    UIApplication.sharedApplication().registerForRemoteNotifications()
  }
  
  //1
  override func viewWillAppear(animated: Bool) {
    loadObjects()
  }
  
  //2
  override func queryForTable() -> PFQuery {
    let query = WallPost.query()
    return query!
  }
  
  //3
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
    //4
    let cell = tableView.dequeueReusableCellWithIdentifier("WallPostCell", forIndexPath: indexPath) as! WallPostTableViewCell
    
    //5
    let wallPost = object as! WallPost
    cell.wallP = wallPost
    cell.cellObjectId = wallPost.objectId
    cell.postImage.file = wallPost.image
    cell.postImage.loadInBackground(nil) { percent in
      cell.progressView.progress = Float(percent)*0.01
      print("\(percent)%")
    }
    
    //7
    let creationDate = wallPost.createdAt
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "HH:mm dd/MM yyyy"
    let dateString = dateFormatter.stringFromDate(creationDate!)
    
    if let username = wallPost.user.username {
      cell.createdByLabel.text = "Uploaded by: \(username), \(dateString)"
    } else {
      cell.createdByLabel.text = "Uploaded by anonymous: , \(dateString)"
    }
    
    cell.commentLabel.text = wallPost.comment
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    //let cell = self.tableView.cellForRowAtIndexPath(indexPath)
    //self.imageSelected = self.tableView.cellForRowAtIndexPath(indexPath) as? WallPostTableViewCell
    let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? WallPostTableViewCell
    wallPostSelected = cell!.wallP

  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "showImageDetails"){
    
     //let imageVC = (segue.destinationViewController as? ImageDetailViewViewController)

      
    }
  }
  
  // MARK: - Actions
  @IBAction func logOutPressed(sender: AnyObject) {
    PFUser.logOut()
    navigationController?.popToRootViewControllerAnimated(true)
  }
}
