//
//  ArticleService.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 30/5/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import Foundation

class ArticleService {
	
	var articleArray : [Article] = []

	//MARK:- ArtcilesFromAPI
	func getArticlesFromAPI(completionHandler: @escaping ([Article]) -> Void) {
        let myDao = NewsDAO()
		myDao.fetchArticles { (articles: [Article]) in
			completionHandler(articles)
		}
	}
	
	//MARK:- FilteredArticles
    func getFilteredArticles(sourceId: String, completionHandler: @escaping ([Article]) -> Void){
        let myDao = NewsDAO()
		myDao.fetchFilteredArticles(sourceId: sourceId) { (articles: [Article]) in
            completionHandler(articles)
        }
    }
    
    func saveArticle(_ article: Article){
        let aNewsDAO = NewsDAO()
        aNewsDAO.SaveArticleInDB(article)
    }
    func getSavedArticles(completionHandler: @escaping ([Article]) -> Void) {
        let myDao = NewsDAO()
        myDao.getSavedArticles{ (articles: [Article]) in
            completionHandler(articles)
        }
    }
        
	//MARK:- Changes
    func removeAnArticle(_ article: Article){
        
        let aNewsDAO = NewsDAO()
        aNewsDAO.removeArticleFromDB(article)
    }
    
    func reloadArticlesIn(articlesArray :[Article],completionHandler: @escaping ([Article]) -> Void){
        
        var articlesArrayToReturn:[Article] = articlesArray
        var savedArticlesArray: [Article] = []
        NewsDAO().getSavedArticles(completionHandler: { (articles) in
            savedArticlesArray = articles
            var index = 0
            for a in articlesArrayToReturn{
                
                for sa in savedArticlesArray{
                    if a.getTitle() == sa.getTitle(){
                        articlesArrayToReturn[index].isSaved = true
                        break
                    } else {
                        articlesArrayToReturn[index].isSaved = false
                    }
                }
                index = index + 1
            }
            completionHandler(articlesArrayToReturn)
        })

    }
	
	func searchByQuery(query: String, completion: @escaping ([Article]) -> ()) {
		
		let newsDataAcces = NewsDAO()
		
		newsDataAcces.searchArticlesByQuery(query) { (response) in
			print("Data Acces termino de obtener los articulos")
			completion(response)
		}
		
	}
	
	//Mark:- Search Articles By Query
	func fetchByQuery(query: String, completion: @escaping ([Article]) -> ()) {
		
		let newsDataAcces = NewsDAO()
		
		newsDataAcces.searchArticlesByQuery(query) { (response) in
			print("Data Acces termino de obtener los articulos")
			completion(response)
		}
		
	}
	
	func filterByDate(query: String, from: Date, to: Date, completion: @escaping ([Article]) -> ()) {
		let newsDataAcces = NewsDAO()
	}

	
}
