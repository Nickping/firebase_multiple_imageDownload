//
//  FeedItem.swift
//  FirebaseTest
//
//  Created by Euijoon Jung on 2018. 8. 11..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit

class FeedItem {
    var key : String
    var image : UIImage
    var headLine : String
    var title : String
    var description : String
    
    init(key_ : String,image_ : UIImage, headLine_ : String, title_ : String, description_ : String) {
        self.key = key_
        self.image = image_
        self.headLine = headLine_
        self.title = title_
        self.description = description_
        
    }
    
    convenience init(){
        self.init(key_ : "",image_ : UIImage(), headLine_ : "", title_ : "", description_: "")
    }
    
}
