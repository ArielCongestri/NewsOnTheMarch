//
//  SpeechPlayerView.swift
//  Proyecto Integrador
//
//  Created by Victor Chang on 17/06/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage


class SpeechPlayerViewController : UIViewController, SpeechDelegate, AVSpeechSynthesizerDelegate {
    
    func changeVolumen(volume: Double) {
    }
    
	func nextArticle() {
        
	}
	
	func playArticle() {

	}
	
	func autoReadArticle() -> Bool {
        return false
	}
	

	var articleArray: [Article] = []
	var synth: AVSpeechSynthesizer = AVSpeechSynthesizer()
    var manualFinishedSpeech : Bool = false
	var wordReader: AVSpeechUtterance?
	var saveArticleDelegate: SaveArticleDelegate?
	var speechDelegate: SpeechDelegate?
	var index = 0
    
    @IBAction func slider(_ sender: Any) {
    }
    @IBAction func nextTapped(_ sender: Any) {
        manualFinishedSpeech = true
        synth.stopSpeaking(at: AVSpeechBoundary.immediate)
        readNextArticle()
        manualFinishedSpeech = false
        
    }
    @IBAction func playOrPauseTapped(_ sender: Any) {
        if synth.isPaused{
            synth.continueSpeaking()
            playOrPauseButton.setImage(UIImage(named: "pause2"), for: .normal)
            
        }else{
            synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
            playOrPauseButton.setImage(UIImage(named: "play2"), for: .normal)
        }
    }
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var volumeSlider: UISlider!
    
	
	override func viewDidLoad() {
        playOrPauseButton.setImage(UIImage(named: "pause2"), for: .normal)
        synth.delegate = self
        setup()
        if articleArray.count > 0 {
            readArticle(articleArray[index])
        }
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2
		
	}
	
	private func readArticle(_ article: Article) {
		let string = "\(article.getTitle())"
		wordReader = AVSpeechUtterance(string: string)
        wordReader?.rate = 0.5
        synth.speak(wordReader!)
	}
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if manualFinishedSpeech{
        }else{readNextArticle()
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        manualFinishedSpeech = true
        synth.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    func readNextArticle(){
        index = index + 1
        if index < articleArray.count{
            setup()
            readArticle(articleArray[index])
        }
        
    }
    
    func setup(){
        let article = articleArray[index]
        titleLabel.text = article.getTitle()
        sourceLabel.text = article.getSource().getName()
        let articleImage = article.getUrlToImage()
        guard let url = URL(string: articleImage) else { return }
        
        //image.image = nil
        
        image.sd_setImage(with: url, completed: nil)
        if image.image == nil {
            image.image = UIImage(named: "noPhoto")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ArticleViewController{
            destination.article = articleArray[index]
        }
    }
}
