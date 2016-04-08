//
//  ImageDetailViewViewController.swift
//  ParseTutorial
//
//  Created by Jeremy Coleman on 4/6/16.
//  Copyright © 2016 Ron Kliffer. All rights reserved.
//

import UIKit

class ImageDetailViewViewController: UIViewController {

  @IBOutlet var postImage: PFImageView?
  @IBOutlet weak var postedBy: UILabel?
  
  var wallPostObject: WallPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(wallPostSelected?.objectId)
      var wallPostImage = PFQuery(className: WallPost.parseClassName())
      wallPostImage.getObjectInBackgroundWithId(wallPostSelected!.objectId!, block:  {
        (imageObject: PFObject?, error: NSError?) -> Void in
        if error == nil {

          self.postedBy!.text = "Loading..."
          let imgObj = imageObject as! WallPost
          let creationDate = imgObj.createdAt
          let dateFormatter = NSDateFormatter()
          dateFormatter.dateFormat = "HH:mm dd/MM yyyy"
          let dateString = dateFormatter.stringFromDate(creationDate!)
          self.postImage!.file = imgObj.image
          print(imgObj.user)
          var userN = PFQuery(className: "_User")
          userN.getObjectInBackgroundWithId(imgObj.user.objectId!, block: {
            (userObject: PFObject?, error: NSError?) -> Void in
            if error == nil {
              let u = userObject as! PFUser
              self.postedBy!.text  = "Uploaded by: \(u.username!), \(dateString)"
            }
          })
          
          //self.postedBy!.text = ("Posted by: \(imgObj.user.username) on \(dateString)")
        } else {
          print("error occured getting object")
        }
      })
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
