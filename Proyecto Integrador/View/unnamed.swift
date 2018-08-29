//
//  unnamed.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 28/6/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class unnamed : UIView {
    
    var myDelegate : SpeechDelegate?
    var viewToSetup : ReusableSpeechView?
    var viewToRetunr : UIView = UIView()
    
    
    private func setUpView(article: Article){
        
    }
    func changeArticle(article: Article, volume: Float?) -> UIView{
        
        return viewToRetunr
    }
    func instanciateView(article: Article, delegate: SpeechDelegate)-> UIView{
        return viewToRetunr
    }
}
