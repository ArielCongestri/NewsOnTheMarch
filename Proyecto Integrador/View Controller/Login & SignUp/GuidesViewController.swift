//
//  GuidesViewController.swift
//  Proyecto Integrador
//
//  Created by Victor Chang on 25/07/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit

class GuidesViewController: UIViewController, UIScrollViewDelegate {
	
    @IBOutlet weak var enjoyLabel: UILabel!
    var scrollView = UIScrollView(frame: CGRect(x:20, y:20, width:320, height: 300))
	var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
	var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
	var pageControl : UIPageControl = UIPageControl(frame: CGRect(x:50,y: 300, width:200, height:50))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let scrollWidth = self.view.frame.width - 40
		let scrollHeight = self.view.frame.height - 100
		
		scrollView = UIScrollView(frame: CGRect(x:20, y:50, width:scrollWidth, height: scrollHeight))
		
		
		//			image.topAnchor.constraint(equalTo: subView.topAnchor, contstant: 0)
		
		
		
		scrollView.delegate = self
		scrollView.isPagingEnabled = true
		
		self.view.addSubview(scrollView)
		var photosNameArray : [String] = ["Page1","Page2","Page3","Page4","finished"]
		for index in 0..<5 {
			setupView(string: photosNameArray[index], index: index)
			
		}
		
		self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 5,height: self.scrollView.frame.size.height)
		pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
		
	}
	
	func configurePageControl() {
		let pageXCoor = self.view.center.x - 100
		let pageYCoor = self.view.frame.height - 40
		
		self.pageControl = UIPageControl(frame: CGRect(x:pageXCoor,y: pageYCoor, width:200, height:50))
		self.pageControl.numberOfPages = 5
		self.pageControl.currentPage = 0
		self.pageControl.tintColor = UIColor.red
		self.pageControl.pageIndicatorTintColor = UIColor.black
		self.pageControl.currentPageIndicatorTintColor = UIColor(displayP3Red: 1, green: 218/255, blue: 68/255, alpha: 1)
		
		
		self.view.addSubview(pageControl)
		
	}
	
	// MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
	@objc func changePage(sender: AnyObject) -> () {
		let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
		scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		
        
		let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        if pageNumber == 4 {
            UIView.animate(withDuration: 1.2, animations: {
                self.enjoyLabel.alpha = 0.07
            }, completion: { (result2) in
                self.performSegue(withIdentifier: "guideFinished", sender: self)
            })
            
        }
		pageControl.currentPage = Int(pageNumber)
	}
	
	func setupView(string: String, index : Int){
		
		frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
		frame.size = self.scrollView.frame.size
		
		var subView = UIView(frame: frame)
        if index != 4{
            subView = GuideView().returnMySelf(string: string)
            subView.frame = frame
        }
		self.scrollView .addSubview(subView)
		configurePageControl()
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}
