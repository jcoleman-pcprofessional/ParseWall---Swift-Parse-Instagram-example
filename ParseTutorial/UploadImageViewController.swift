//
//  UploadImageViewController.swift
//  ParseTutorial
//
//  Created by Ron Kliffer on 3/6/15.
//  Copyright (c) 2015 Ron Kliffer. All rights reserved.
//

import UIKit

class UploadImageViewController: UIViewController {
  
  @IBOutlet weak var imageToUpload: UIImageView!
  @IBOutlet weak var commentTextField: UITextField!
  @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
  
  var username: String?
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  // MARK: - Actions
  @IBAction func selectPicturePressed(sender: AnyObject) {
    //Open a UIImagePickerController to select the picture
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func sendPressed(sender: AnyObject) {
    commentTextField.resignFirstResponder()
    
    //Disable the send button until we are ready
    navigationItem.rightBarButtonItem?.enabled = false
    
    loadingSpinner.startAnimating()
    
    //TODO: Upload a new picture
    //print(imageToUpload)
    
    if (imageToUpload.image != nil && imageToUpload.image != "") {
    let pic = imageToUpload.image!

    var pictureData = UIImageJPEGRepresentation(imageToUpload.image!, 1.0)
    let under10 = imageFileSize(pictureData!)
      print("Under10:  \(under10)")
      if !under10 {
        let newPic = pic.lowQualityJPEGNSData
        pictureData = newPic
      } else {
        pictureData = UIImageJPEGRepresentation(imageToUpload.image!, 1.0)
      }
    //1
    let file = PFFile(name: "image2", data: pictureData!)

    file!.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
      if succeeded {
        //2
        self.saveWallPost(file!)
      } else if let error = error {
        //3
        self.showErrorView(error)
      }
      }, progressBlock: { percent in
        //4
        print("Uploaded: \(percent)%")
    })
      }
  }
  func saveWallPost(file: PFFile?)
  {
    //1
    var wallPost: WallPost
    if file != nil {
    wallPost = WallPost(image: file!, user: PFUser.currentUser()!, comment: self.commentTextField.text)
    } else {

      wallPost = WallPost(user: PFUser.currentUser()!, comment: self.commentTextField.text)
    }
    //2
    wallPost.saveInBackgroundWithBlock{ succeeded, error in
      if succeeded {
        //3
        self.navigationController?.popViewControllerAnimated(true)
      } else {
        //4
        if let errorMessage = error?.userInfo["error"] as? String {
          print("Error Message:  \(errorMessage)")
          self.showErrorView(error!)
        }
      }
    }
  }
  
}

extension UploadImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    //Place the image in the imageview
    imageToUpload.image = image
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
}

func imageFileSize(fData: NSData) -> Bool {
  print("DATA SIZE:  \(fData.length)")
  if (fData.length) <= 10485760 {
    return true
  } else {
    return false
  }
}

extension UIImage
{
  var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)! }
  var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)!}
  var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)! }
  var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)!}
  var lowestQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.0)! }
}