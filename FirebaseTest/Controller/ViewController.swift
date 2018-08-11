//
//  ViewController.swift
//  FirebaseTest
//
//  Created by Euijoon Jung on 2018. 8. 11..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseStorage
import FirebaseDatabase



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var feeds : [FeedItem] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedTableView") as! FeedTableViewCell
        let feedInfo = feeds[indexPath.row]
        
        cell.headLineLabel.text = feedInfo.headLine
        cell.titleLabel.text = feedInfo.title
        cell.descriptionLabel.text = feedInfo.description
        cell.mainImageView.image = feedInfo.image
        return cell
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        downloadFromServer()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (action, sourceView, completionHandler) in
            let DBref = Database.database().reference().child("user/feed/\(self.feeds[indexPath.row].key)")
            let STref = Storage.storage().reference().child("user/feed/\(self.feeds[indexPath.row].key)")
            STref.delete(completion: { (error) in
                
            })
            DBref.removeValue()
            
            self.feeds.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
            
            
            
        }
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionConfiguration
    }
    
    
    //download from server
    func downloadFromServer(){
        SVProgressHUD.show()

        
        print("downloadFromServer")
        let DBRef = Database.database().reference().child("user/feed/")
        let STRef = Database.database().reference().child("user/feed/")
        let rootRef = Database.database().reference()
        
    
        rootRef.observe(.value) { (snapshot) in
            if snapshot.hasChildren() == false {
                SVProgressHUD.dismiss()
            }
        }
        
        
        DBRef.observe(.childAdded) { (snapshot) in
            print("Firebase DB Observe!!")
            let data = snapshot.value as! Dictionary<String,AnyObject>
        
            var newFeed = FeedItem()
            do{
                newFeed.key = snapshot.key
                let str = data["imageUrl"] as! String
                
                let imageUrl = URL(string:str)
                
                do{
                    let imageData = try Data(contentsOf: imageUrl!)
                    newFeed.image = UIImage(data: imageData)!
                }catch{
                    
                }
                newFeed.headLine = data["headLine"] as! String
                newFeed.title = data["title"] as! String
                newFeed.description = data["description"] as! String
                self.feeds.append(newFeed)
                print(data["user"])
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
            catch{
                SVProgressHUD.dismiss()
            }
        }
        
        
        
    }
    //reload
    
    //add new feed controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewFeed"{
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

