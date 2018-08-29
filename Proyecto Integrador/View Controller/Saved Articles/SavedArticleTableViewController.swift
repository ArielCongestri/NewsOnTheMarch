//
//  SavedArticleTableViewController.swift
//  Proyecto Integrador
//
//  Created by Victor Chang on 02/06/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit

class SavedArticleTableViewController: UITableViewController, SaveArticleDelegate {
	func saveArticleFromDetail() {
		
	}
	
	func SaveArticleFromDetail() {
	}
	
	func SaveArticleFromDetail(article: Article) {
		
		let anArticleService = ArticleService()
		if article.isSaved {
			anArticleService.removeAnArticle(article)
			article.isSaved = false
		}else{
			anArticleService.saveArticle(article)
			article.isSaved = true
		}
	}
	
	
    func updateSavedArticles(_ article: Article) {
		for anArticle in articleArray {
			if anArticle.getTitle() == article.getTitle() && anArticle.getDescription() == article.getDescription() {
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
             myArticleService.getSavedArticles(completionHandler: { (articles) in
                self.articleArray = articles
                if self.articleArray[0].getUrl() == "noURL"{
                    self.articleArray.remove(at: 0)
                }
                self.tableView.reloadData()
            })
        }
	}
	
	
	var articleArray: [Article] = []
	var myArticleService = ArticleService()

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
        myArticleService.getSavedArticles(completionHandler: { (articles) in
            self.articleArray = articles
            if self.articleArray[0].getUrl() == "noURL"{
                self.articleArray.remove(at: 0)
            }
            self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleTableViewCell")
            self.tableView.tableFooterView = UIView()
        })



    }
	
	private func getArticle(indexPath: IndexPath) -> Article? {
		let news = articleArray[indexPath.row]
		return news
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ArticleService().getSavedArticles { (articles) in
            self.articleArray = articles
            if self.articleArray[0].getUrl() == "noURL"{
                self.articleArray.remove(at: 0)
            }
            self.tableView.reloadData()
        }

    }

    // MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabel()
		label.text = "You have no bookmarked articles..."
		label.textAlignment = .center
		label.textColor = UIColor(red: 1, green: 208/255, blue: 68/255, alpha: 1)
		label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		return label
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return self.articleArray.count > 0 ? 0 : 250
	}
	
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
		return 120
	}

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleTableViewCell", for: indexPath)

		if let savedCell = cell as? ArticleTableViewCell, let article = getArticle(indexPath: indexPath) {
			savedCell.setupWith(article, delegate: self)
		}
		
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SavedArticleDetailViewController {
            if let selectedArticle = tableView.indexPathForSelectedRow {
                destination.myArticle = articleArray[selectedArticle.row]
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSaved", sender: self)
    }

}
