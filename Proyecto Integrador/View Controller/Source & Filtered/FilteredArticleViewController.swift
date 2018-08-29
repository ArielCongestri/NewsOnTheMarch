//
//  FilteredArticleViewController.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 3/6/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import AVFoundation

class FilteredArticleDetailViewController: UIViewController, SpeechDelegate, SaveArticleDelegate, WebViewDelegate, AVSpeechSynthesizerDelegate {
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
	
	func toggleSpeechPlayerView(article: Article) {
//		let window = UIApplication.shared.keyWindow
//		let speechPlayerView = Bundle.main.loadNibNamed("SpeechPlayerView", owner: self, options: nil)?.first as! SpeechPlayerView
//		
//		speechPlayerView.frame = self.view.frame
//		window?.addSubview(speechPlayerView)
	}
	
	func toWebPage() {
		performSegue(withIdentifier: "sourceWebView", sender: self)
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
	
	var synth = AVSpeechSynthesizer()
    var myArticle : Article?
	
	override func viewDidDisappear(_ animated: Bool) {
		synth.stopSpeaking(at: AVSpeechBoundary.immediate)
        

	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view = ReusableCustomView().returnView(forArticle: myArticle!, delegate: self)
        synth.delegate = self
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? WebSourceViewController {
			
			destination.url = (myArticle?.getUrl())!
			
		}
	}
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("termine")
        self.view = ReusableCustomView().returnView(forArticle: myArticle!, delegate: self)
    }
    
	
	}



