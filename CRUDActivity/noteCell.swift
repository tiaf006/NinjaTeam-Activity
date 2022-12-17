//
//  noteCell.swift
//  CRUDActivity
//
//  Created by TAIF Al-zahrani on 23/05/1444 AH.
//

import UIKit

class noteCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var textLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       //contentView.backgroundColor = UIColor(patternImage: (UIImage(named: "cc")!))
        backgroundView = UIImageView(image: UIImage(named: "111"))
        layer.masksToBounds = false
            //layer.shadowOpacity = 0.20
               // layer.shadowRadius = 16
               // layer.shadowOffset = CGSize(width: 0, height: 0)
               // layer.shadowColor = UIColor.black.cgColor
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 8
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
