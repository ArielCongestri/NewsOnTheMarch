//
//  FilteredArticleTableViewCell.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 30/5/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit

class FilteredArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupWith(_ article: Article) {
        titleLabel.text = article.getTitle()
        publishedLabel.text = "Fecha de publicación: \(article.getPublishedAt())"
        authorLabel.text = "Publicado por: \(article.getAuthor())"
        
    }

}
