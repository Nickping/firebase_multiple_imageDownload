//
//  FeedTableViewCell.swift
//  FirebaseTest
//
//  Created by Euijoon Jung on 2018. 8. 11..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet var mainImageView : UIImageView!
    @IBOutlet var headLineLabel : UILabel!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var descriptionLabel : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
