//
//  ArticleViewController.swift
//  Proyecto Integrador
//
//  Created by Andres Ciaño on 15/05/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

protocol WebViewDelegate {
	func toWebPage()
}

import UIKit
import AVFoundation

class ArticleViewController: UIViewController, SaveArticleDelegate, SpeechDelegate, WebViewDelegate, AVSpeechSynthesizerDelegate{
	func saveArticleFromDetail() {
		
				let anArticleService = ArticleService()
		if let article = article {
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
	
	func toggleSpeechPlayerView(article: Article) {
//		let window = UIApplication.shared.keyWindow
//		let speechPlayerView = Bundle.main.loadNibNamed("SpeechPlayerView", owner: self, options: nil)?.first as! SpeechPlayerView
//
//		speechPlayerView.frame = self.view.frame
//		window?.addSubview(speechPlayerView)
	}
	
	func toWebPage() {
		performSegue(withIdentifier: "articleWebView", sender: self)
	}
	
	func SaveArticleFromDetail() {
		let anArticleService = ArticleService()
		if let anArticle = article {
			if anArticle.isSaved {
				anArticleService.removeAnArticle(anArticle)
				anArticle.isSaved = false
			}else{
				anArticleService.saveArticle(anArticle)
				anArticle.isSaved = true
			}
		}
	}
	
	
	func updateSavedArticles(_ article: Article) {
	}

	
	func toggleSaveArticle(cell: UITableViewCell) {
			let anArticleService = ArticleService()
		if (article?.isSaved)! {
			anArticleService.removeAnArticle(article!)
				article?.isSaved = false
			}else{
			anArticleService.saveArticle(article!)
				article?.isSaved = true
			}
		
	}

    var article: Article?
	var synth: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		UserDefaults.standard.set(false, forKey: "firtsTime")
        synth.delegate = self
//        self.view = ReusableCustomView().returnView(forArticle: article!, delegate: self)
		presentArticleView()
    }
	
	func presentArticleView() {
		guard let article = article else { return }
		self.view = ReusableCustomView().returnView(forArticle: article, delegate: self)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		synth.stopSpeaking(at: AVSpeechBoundary.immediate)
		
	}

	public func autoReadArticle()-> Bool {
        if synth.isSpeaking{
            if synth.isPaused{
                synth.continueSpeaking()
                return true
            } else {
                synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
                return false
            }
        } else {
            var string = ""
            if let text = article?.getDescription() {
                string = "\(text)"
            }
            let utterance = AVSpeechUtterance(string: string)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synth.speak(utterance)
            return true
        }
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? WebArticleViewController {
			
			destination.url = (article?.getUrl())!
		}
		if let destination = segue.destination as? GuidesViewController {
			print("tuvieja", destination)
		}
	}
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.view = ReusableCustomView().returnView(forArticle: article!, delegate: self)
    }
    
	
	
}

