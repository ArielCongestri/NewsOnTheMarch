//
//  SearchViewController.swift
//  Proyecto Integrador
//
//  Created by Victor Chang on 09/07/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UISearchBarDelegate, SaveArticleDelegate, UITableViewDelegate, UITableViewDataSource {
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
	

	
	// MARK:- var, lets & Outlets
	@IBOutlet weak var tableView: UITableView!
	
	let searchController = UISearchController(searchResultsController: nil)
	let articleService = ArticleService()
	var articleArray: [Article] = []

	var searchQuery: String?
	
    override func viewDidLoad() {
		
		
        super.viewDidLoad()
		
//		articleService.getArticlesFromAPI { (articles: [Article]) in
//			self.articleArray = articles
//			self.tableView.reloadData()
//		}
		setupSearchBar()
		setupTableView()
		self.navigationController?.navigationBar.barStyle = UIBarStyle.black
		}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	fileprivate func setupSearchBar() {
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
		searchController.searchBar.placeholder = "Search articles..."
		definesPresentationContext = true
		
		searchController.searchBar.tintColor = .white
	}
	
	var timer: Timer?
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { (timer) in
			let service = ArticleService()
			if let searchText = searchBar.text {
				service.fetchByQuery(query: searchText) { (articles) in
					self.articleArray = articles
					self.tableView?.reloadData()
				}
			}
		})
	}
	
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let articleSearchingView = Bundle.main.loadNibNamed("ArticleSearchingView", owner: self, options: nil)?.first as? UIView
		return articleSearchingView
//		let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
//		activityIndicatorView.color = .darkGray
//		activityIndicatorView.startAnimating()
//		return activityIndicatorView
	}
	
	@objc override func dismissKeyboard() {

	}
	
	private func getArticle(indexPath: IndexPath) -> Article? {
		let news = articleArray[indexPath.row]
		return news
	}

	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		return false
	}
	
	fileprivate func setupTableView() {
		tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "articleTableViewCell")
		tableView.tableFooterView = UIView()
		tableView.delegate = self
		tableView.dataSource = self
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return articleArray.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "articleTableViewCell", for: indexPath)
		if let articlesCell = cell as? ArticleTableViewCell, let article = getArticle(indexPath: indexPath) {
			articlesCell.setupWith(article, delegate: self)
		}

		return cell
	}
	 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 120
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return articleArray.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabel()
		label.text = "Please enter a Search Term"
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		label.textColor = UIColor(red: 1, green: 208/255, blue: 68/255, alpha: 1)
		
//		let button = UIButton()
//		button.setTitle("Start Browsing", for: .normal)
//		button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//		button.tintColor = .darkGray
//		button.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 1)
//		button.anchor(top: label.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 40)
		
		return label
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return self.articleArray.isEmpty && searchController.searchBar.text?.isEmpty == true ? 250 : 0
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "toArticle", sender: self)

	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? ArticleViewController {
			if let selectedArticle = tableView.indexPathForSelectedRow {
				destination.article = articleArray[selectedArticle.row]
				destination.navigationItem.backBarButtonItem?.tintColor = .yellow
			}
		}

	}
}
