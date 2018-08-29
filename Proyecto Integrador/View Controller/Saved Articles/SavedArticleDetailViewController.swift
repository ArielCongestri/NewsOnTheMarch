//
//  SavedArticleDetailViewController.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 3/6/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import AVFoundation

class SavedArticleDetailViewController: UIViewController, SpeechDelegate, SaveArticleDelegate, WebViewDelegate, AVSpeechSynthesizerDelegate {
	func saveArticleFromDetail() {
		let anArticleService = ArticleService()
		if let article = myArticle {
			if article.isSaved {
				anArticleService.removeAnArticle(article)
				article.isSaved = false
			} else {
				anArticleService.saveArticle(article)
				article.isSaved = true
			}
		}
	}
	
    func changeVolumen(volume: Double) {
        
    }
    
    
	func nextArticle() {
		
	}
	
	func playArticle() {
		
	}
	
	
	func toWebPage() {
		performSegue(withIdentifier: "savedWebView", sender: self)
	}
	
	func updateSavedArticles(_ article: Article) {
		
	}
	
	func toggleSaveArticle(cell: UITableViewCell) {

	}
	
	func SaveArticleFromDetail() {
		let anArticleService = ArticleService()
		if let anArticle = myArticle {
			if anArticle.isSaved {
				anArticleService.removeAnArticle(anArticle)
				anArticle.isSaved = false
			}else{
				anArticleService.saveArticle(anArticle)
				anArticle.isSaved = true
			}
		}

	}
	
    public func autoReadArticle()-> Bool {
        if synth.isSpeaking{
            if synth.isPaused{
                synth.continueSpeaking()
                return true
            }else{
                synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
                return false
            }
        }else{
            var string = ""
            if let text = myArticle?.getDescription() {
                string = "\(text)"
            }
            let utterance = AVSpeechUtterance(string: string)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synth.speak(utterance)
            return true
        }
    }
	

    var myArticle : Article?
	var synth = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synth.delegate = self
        self.view = ReusableCustomView().returnView(forArticle: myArticle!, delegate: self)
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		synth.stopSpeaking(at: AVSpeechBoundary.immediate)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? WebSavedViewController {
			
			guard let articleUrl = myArticle?.getUrl() else { return }
			destination.url = articleUrl
			
		}
	}
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.view = ReusableCustomView().returnView(forArticle: myArticle!, delegate: self)
    }

}
