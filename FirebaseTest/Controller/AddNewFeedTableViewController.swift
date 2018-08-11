//
//  AddNewFeedTableViewController.swift
//  FirebaseTest
//
//  Created by Euijoon Jung on 2018. 8. 11..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

// /user/feed/(autobyIdKey)

/*
 {
 userId : "",
 imageUrl : "",
 headLine : "",
 title : "",
 description : ""
 
 }
 
 */

class AddNewFeedTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var headLineTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    @IBAction func onSaveButtonClicked(_ sender: UIBarButtonItem) {
        SVProgressHUD.show()
        var DBRef = Database.database().reference().child("/user/feed/")
        var STRef = Storage.storage().reference().child("/user/feed/")
        let key = DBRef.childByAutoId().key
        STRef = STRef.child(key)
        
        if imageView.image != nil {
            let data = UIImageJPEGRepresentation(imageView.image!, 0.01)
            STRef.putData(data!).observe(.success) { (snapshot) in
                if snapshot.error != nil {
                    
                    SVProgressHUD.dismiss()
                    let alertController = UIAlertController(title: "", message: "upload failed", preferredStyle: .alert)
                    let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alert)
                    self.present(alertController, animated: true, completion: nil)
                    print(snapshot.error)
                }else {
                    
                    STRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print("downloadError!!!")
                            print(error)
                            SVProgressHUD.dismiss()
                            DBRef = DBRef.child(key)
                            let dataDic : [String: AnyObject] =
                                ["user" : "dordong" as AnyObject ,
                                 "imageUrl" : url?.absoluteString as AnyObject,
                                 "headLine" : self.headLineTextField.text as AnyObject,
                                 "title": self.titleTextField.text as AnyObject,
                                 "description" : self.descriptionTextField.text as AnyObject]
                            DBRef.setValue(dataDic)
                            let alertController = UIAlertController(title: "", message: "download url error", preferredStyle: .alert)
                            let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alert)
                            self.present(alertController, animated: true, completion: nil)
                        }else {
                            SVProgressHUD.dismiss()
                            print(url?.absoluteString)

                            DBRef = DBRef.child(key)
                            let dataDic : [String: AnyObject] =
                                ["user" : "dordong" as AnyObject ,
                                 "imageUrl" : url?.absoluteString as AnyObject,
                                 "headLine" : self.headLineTextField.text as AnyObject,
                                 "title": self.titleTextField.text as AnyObject,
                                 "description" : self.descriptionTextField.text as AnyObject]
                            DBRef.setValue(dataDic)
                            let alertController = UIAlertController(title: "", message: "upload success", preferredStyle: .alert)
                            let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alert)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    })
                    
                    
                }
            }
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            alertController.addAction(photoLibraryAction)
            present(alertController, animated: true, completion: nil)
            
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            
        }
        
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: imageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: imageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: imageView.superview, attribute: .top, multiplier: 1, constant: 0)
        
        topConstraint.isActive = true
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: imageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        
        bottomConstraint.isActive = true
        
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    //
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
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
