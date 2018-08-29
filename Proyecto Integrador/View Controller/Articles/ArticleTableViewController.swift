//
//  ArticleTableViewController.swift
//  Proyecto Integrador
//
//  Created by VictorCh on 24/05/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

protocol SaveArticleDelegate {
    func updateSavedArticles(_ article: Article)
    func toggleSaveArticle(cell: UITableViewCell)
	func saveArticleFromDetail()

}

class ArticleTableViewController: UITableViewController, SaveArticleDelegate{
	func saveArticleFromDetail() {
		
	}
	

	
	
    func updateSavedArticles(_ article: Article) {
        for anArticle in articleArray {
            if anArticle.getTitle() == article.getTitle() &&
                anArticle.getDescription() == article.getDescription() {
                anArticle.isSaved = article.isSaved
                break
            }
        }
            tableView.reloadData()
    }
    
    func toggleSaveArticle(cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let article = articleArray[indexPath.row]
            let anArticleService = ArticleService()
            if article.isSaved {
                anArticleService.removeAnArticle(article)
                article.isSaved = false
            }else{
                anArticleService.saveArticle(article)
                article.isSaved = true
            }
            tableView.reloadData()
        }
	}
	//MARK:- vars & lets
	var refresher: UIRefreshControl! = UIRefreshControl()
    var articleArray: [Article] = []
    let myArticleService = ArticleService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
//		setupNavBarButton()
		if Auth.auth().currentUser == nil {
			DispatchQueue.main.async {
				let loginController = LoginViewController()
				self.present(loginController, animated: true, completion: nil)
			}
			return
		}

		myArticleService.getArticlesFromAPI { (articles: [Article]) in
			self.articleArray = articles
			self.tableView.reloadData()
		}
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleTableViewCell")
		tableView.tableFooterView = UIView()
	
		tableRefresher()
        
	}
	
	func tableRefresher() {
    
		refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
		refresher.addTarget(self, action: #selector(setupRefreshCallback), for:
		UIControlEvents.valueChanged)
        
		tableView.addSubview(refresher)
	}

	@objc func setupRefreshCallback() {
		let service = ArticleService()
		service.getArticlesFromAPI { (articles) in
			self.articleArray.append(contentsOf: articles)
            self.refresher.endRefreshing()
			self.tableView.reloadData()
		}
	}
	

	
	func setupNavBarButton() {
		let speechButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
			speechButton.setImage(UIImage.init(named:"headPhones"), for: .normal)
		
		speechButton.imageView?.frame.size.height = 5
		speechButton.imageView?.frame.size.width = 5
		speechButton.contentMode = .scaleAspectFit
//		speechButton.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: speechButton)
		speechButton.addTarget(self, action: #selector(speechPlayerToggled), for: .touchUpInside)
	}
	
	@objc fileprivate func speechPlayerToggled() {
		
	}
	
	fileprivate func speechSynthesize() {
		let synth = AVSpeechSynthesizer()
		let string = ""
		let utterance = AVSpeechUtterance(string: string)
		utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
		synth.speak(utterance)
	}
    
    private func getArticle(indexPath: IndexPath) -> Article? {
        let news = articleArray[indexPath.row]
        return news
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // tengo que recargar el array cada vez que aparece la pantalla para actualizar
    // los favoritos que se marcaron en los demas controlers
    
    override func viewDidAppear(_ animated: Bool) {
        myArticleService.reloadArticlesIn(articlesArray: self.articleArray) { (articles) in
            self.articleArray = articles
            self.tableView.reloadData()
        }

    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleTableViewCell", for: indexPath)

        if let articlesCell = cell as? ArticleTableViewCell, let article = getArticle(indexPath: indexPath){
            articlesCell.setupWith(article, delegate: self)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? ArticleViewController {
            if let selectedArticle = tableView.indexPathForSelectedRow {
                destination.article = articleArray[selectedArticle.row]
            }
        }
		
		if let destination = segue.destination as? SpeechPlayerViewController{
			destination.articleArray = self.articleArray
		}
    }

}
    


