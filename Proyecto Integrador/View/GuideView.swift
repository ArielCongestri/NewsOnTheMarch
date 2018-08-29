//
//  GuideView.swift
//  Proyecto Integrador
//
//  Created by Victor Chang on 25/07/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit

class GuideView: UIView {
	

	@IBOutlet weak var imageView: UIImageView!
	
	func returnMySelf(string: String) -> UIView{
		let v = Bundle.main.loadNibNamed("GuideView", owner: self, options: nil)?.first as? GuideView
		v?.imageView.image = UIImage(named: string)
		let view : UIView = v!
		return view
	}

}
