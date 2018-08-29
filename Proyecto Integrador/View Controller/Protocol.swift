//
//  Protocol.swift
//  Proyecto Integrador
//
//  Created by Victor Chang on 18/06/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import Foundation

protocol SpeechDelegate {
	
	func autoReadArticle()->Bool
	func nextArticle()
	func playArticle()
    func changeVolumen(volume: Double)
    
}

protocol FilterDelegate{
    func setFilter(selectedCategories: [String])
}
