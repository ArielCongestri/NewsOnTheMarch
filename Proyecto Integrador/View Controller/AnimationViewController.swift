//
//  AnimationViewController.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 27/5/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {
    
    var customImageView: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		setInitAnimation()
		
    }
	
	fileprivate func setInitAnimation() {
	let myPhoto = UIImage(named: "SplashScreen_05")
	customImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))

	customImageView.image = myPhoto
	customImageView.contentMode = .scaleAspectFit
	view.addSubview(customImageView)
	}
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 1.8, animations: {
            self.customImageView.alpha = 0.05
        }, completion: { (result2) in
            self.performSegue(withIdentifier: "animation", sender: self)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    */
}
