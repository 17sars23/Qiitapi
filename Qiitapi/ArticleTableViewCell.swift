//
//  ArticleTableViewCell.swift
//  Qiitapi
//
//  Created by 川岸樹奈 on 2019/02/22.
//  Copyright © 2019年 juna.Kawagishi. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var dateLabel: UILabel!
    var dateInfo: String!
    @IBOutlet var userIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
