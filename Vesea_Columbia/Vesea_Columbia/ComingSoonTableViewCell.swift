//
//  ComingSoonTableViewCell.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 8/21/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit

class ComingSoonTableViewCell: UITableViewCell {
    
    var delegate : ListViewController?
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!

    @IBAction func buttonPressed(sender: AnyObject) {
        delegate!.showQuestionForm()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
