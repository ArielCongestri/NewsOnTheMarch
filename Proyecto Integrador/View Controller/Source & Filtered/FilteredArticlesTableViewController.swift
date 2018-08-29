//
//  FilteredsArticlesTableViewController.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 30/5/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit

class FilteredArticlesTableViewController: UITableViewController, SaveArticleDelegate {
	func saveArticleFromDetail() {
		
	}
	
	
    func updateSavedArticles(_ article: Article) {
        for anArticle in articles {
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
            let article = articles[indexPath.row]
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
    
    
    var articles : [Article] = []
    var sourceId : String = ""
    var myArticleService = ArticleService()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(sourceId)
		tableView.tableFooterView = UIView()
        myArticleService.getFilteredArticles(sourceId: sourceId) { (articles: [Article]) in
            self.articles = articles
            self.tableView.reloadData()
        }

        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleTableViewCell")
		
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myArticleService.reloadArticlesIn(articlesArray: self.articles, completionHandler: { (articles) in
            self.articles = articles
            self.tableView.reloadData()
        })
        
    }
    
    private func getArticle(indexPath: IndexPath) -> Article? {
        let news = articles[indexPath.row]
        return news
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    // No reconoce el tamaño de la celda preseleccionado entonces lo harcodeo
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleTableViewCell", for: indexPath)
        
        if let articlesCell = cell as? ArticleTableViewCell, let article = getArticle(indexPath: indexPath){
            articlesCell.setupWith(article, delegate: self)
        }
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FilteredArticleDetailViewController {
            if let selectedArticle = tableView.indexPathForSelectedRow {
                destination.myArticle = articles[selectedArticle.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailFiltered", sender: self)
    }
    

}
