//
//  ArticleTableViewCell.swift
//  Proyecto Integrador
//
//  Created by VictorCh on 24/05/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var saveArticleButtonLabel: UIButton!
	
    
    var saveArticleDelegate: SaveArticleDelegate?
	var speechDelegate: SpeechDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Mark: - SetupWith()
    public func setupWith(_ article: Article, delegate: SaveArticleDelegate) {
        saveArticleDelegate = delegate
        titleLabel.text = article.getTitle()
		sourceLabel.text = article.getSource().getName()

		guard let timeAgoDisplay = article.getDate()?.timeAgoDisplay() else { return }
		publishedLabel.text = "\(timeAgoDisplay)"		
		
        let articleImage = article.getUrlToImage()
        guard let url = URL(string: articleImage) else { return }
        
		
		imageLabel.sd_setImage(with: url, completed: nil)
        if imageLabel.image == nil {
            imageLabel.image = UIImage(named: "noPhoto")
        }
        
        if article.isSaved {
           
            saveArticleButtonLabel.setImage(UIImage(named: "readLaterBlack"), for: .normal)
        } else {
            saveArticleButtonLabel.setImage(UIImage(named: "readLater"), for: .normal)
        }
    }
    
    @IBAction func saveArticleButtonPressed(_ sender: UIButton) {
        saveArticleDelegate?.toggleSaveArticle(cell: self)
    }
	
	@IBAction func speechButtonPressed(_ sender: UIButton) {
		


	}
	
}
