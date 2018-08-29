//
//  ReusableCustomView.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 3/6/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

class ReusableCustomView: UIView {
	
	var saveDelegate : SaveArticleDelegate?
	var webViewDelegate : WebViewDelegate?
	var speechDelegate: SpeechDelegate?
	
    func returnView(forArticle: Article, delegate: SpeechDelegate) -> UIView? {
       
        let v = Bundle.main.loadNibNamed("ReusableCustomView", owner: self, options: nil)?.first as? ReusableCustomView
		v?.setupWith(forArticle, delegate: delegate)
        let view : UIView = v!
        return view
	
    }
    
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var readLaterButton: UIButton!
	@IBOutlet weak var articleTitleLabel: UILabel!
	@IBOutlet weak var sourceLabel: UILabel!
	@IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

	@IBAction func toWebPageButton(_ sender: UIButton) {
		webViewDelegate?.toWebPage()
		
	}
	
	@IBAction func readLaterButton(_ sender: Any) {
		saveDelegate?.saveArticleFromDetail()
		let image = UIImage(named: "readLater")
		let button = UIButton()
		button.setImage(image, for: .normal)
		if readLaterButton.imageView?.image == button.imageView?.image {
			
			readLaterButton.setImage(UIImage(named: "readLaterBlack"), for: .normal)
		} else {
			readLaterButton.setImage(UIImage(named: "readLater"), for: .normal)
		}
	}
	
	var synth: AVSpeechSynthesizer = AVSpeechSynthesizer()

	@IBAction func speechButtonPressed(_ sender: Any) {
		let isSpeaking = speechDelegate?.autoReadArticle()
        if isSpeaking! {
            print("esta hablando")
            speechButton.setImage(UIImage(named: "speechON"), for: .normal)
        }else{
            speechButton.setImage(UIImage(named: "headPhones"), for: .normal)
        }
	}
    
	public func setupWith(_ article: Article, delegate: SpeechDelegate ) {
		
        articleTitleLabel.adjustsFontSizeToFitWidth = true
        articleTitleLabel.minimumScaleFactor = 0.2
		speechDelegate = delegate
		webViewDelegate = delegate as? WebViewDelegate
		saveDelegate = delegate as? SaveArticleDelegate
        
        articleTitleLabel.text = article.getTitle()
        descriptionTextView.text = article.getDescription()
		sourceLabel.text = "\(article.getSource().getName())"
		
		guard let timeAgoDisplay = article.getDate()?.timeAgoDisplay() else { return }
		publishedLabel.text = "Published \(timeAgoDisplay)"
		
		
        let articleImage = article.getUrlToImage()
        guard let url = URL(string: articleImage) else { return }
		
		
		imageView.sd_setImage(with: url, completed: nil)
        
        if imageView.image == nil {
            imageView.image = UIImage(named: "noPhoto")
        }
        
        
		if article.isSaved {
			
			readLaterButton.setImage(UIImage(named: "readLaterBlack"), for: .normal)
		} else {
			readLaterButton.setImage(UIImage(named: "readLater"), for: .normal)
		}
		
	}
}
