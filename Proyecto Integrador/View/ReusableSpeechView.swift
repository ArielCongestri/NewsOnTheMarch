//
//  ReusableSpeechView.swift
//  Proyecto Integrador
//
//  Created by Victor Chang on 27/06/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

class ReusableSpeechView: UIView {

	var myDelegate: SpeechDelegate?
    var viewToSetup : ReusableSpeechView?
    var viewToRetunr : UIView = UIView()
    
	@IBOutlet weak var speechPlayerImage: UIImageView!
	@IBOutlet weak var articleTitleLabel: UILabel!
	@IBOutlet weak var sourceLabel: UILabel!
    

    @IBAction func nextButton(_ sender: Any) {
        if myDelegate == nil{
            print("no tengo delegate")
        }
        
    }
    @IBAction func toArticleButtonPress(_ sender: Any) {
		
	}
	
	func returnView(forArticle: Article, delegate: SpeechDelegate) -> UIView {
		
        myDelegate = delegate
		viewToSetup = Bundle.main.loadNibNamed("SpeechPlayerView", owner: self, options: nil)?.first as? ReusableSpeechView
        
		viewToSetup?.setup(article: forArticle)
        
        if let view = viewToSetup{
            viewToRetunr = view
        }
		return viewToRetunr
	}
	
	private func setup(article: Article) {
		articleTitleLabel.text = article.getTitle()
		sourceLabel.text = article.getSource().getName()
		let articleImage = article.getUrlToImage()
		guard let url = URL(string: articleImage) else { return }
		
		speechPlayerImage.image = nil
		
		speechPlayerImage.sd_setImage(with: url, completed: nil)
        
    }
    
    
    @IBAction func playButton(_ sender: UIButton) {
        myDelegate?.playArticle()
    }
   

    func actualizeView(forArticle: Article, volume: Float?) -> UIView {
        print("cambio la view")
        if myDelegate == nil{
            print("no tengo delegate")
        }
        viewToSetup?.setup(article: forArticle)
        if let view = viewToSetup{
            viewToRetunr = view
        }
        return viewToRetunr
    }
    

    
    
}
