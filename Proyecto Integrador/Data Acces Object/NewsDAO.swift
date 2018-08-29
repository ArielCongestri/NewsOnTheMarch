//
//  APIService.swift
//  Proyecto Integrador
//
//  Created by Victor Chang on 06/06/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

class NewsDAO{
    
    var ref: DatabaseReference! = Database.database().reference()
    let storageRef = Storage.storage().reference()
	
	let newsFromArgUrl = NewsHelper.getTopheadlinesPorPais(pais: NewsHelper.country_ARGENTINA)
	let newsFromUsUrl = NewsHelper.getTopheadlinesPorPais(pais: NewsHelper.country_ESTADOSUNIDOS)
	//static let shared = NewsDAO()
	
    func fetchArticles(completionHandler: @escaping ([Article] ) -> Void) {
		let miCompletionHandler = {(response: DataResponse<Any>)-> Void in
            var dictionaryArray : [[String:AnyObject]] = [[:]]
            self.ref.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? NSDictionary{
                    if let array = dictionary.allValues as? [[String:AnyObject]]{
                        dictionaryArray = array
                        
                    }
                }
                var resultArray : [Article] = []
                if let json = response.result.value as? [String: AnyObject] {
                    if let articles = json["articles"] as? [[String:AnyObject]]{
                        
                        for article in articles {
                            let myArticle = Article(with: article)
                            
                            for d in dictionaryArray{
                                if myArticle.getTitle() == d["title"] as! String?{
                                    myArticle.isSaved = true
                                    break
                                }
                            }
                            resultArray.append(myArticle)
                        }
                        completionHandler(resultArray)
                    }
                }
            }
                

	}
		Alamofire.request(newsFromUsUrl).responseJSON(completionHandler: miCompletionHandler)
	}
    
    func fetchFilteredArticles(sourceId: String ,completionHandler: @escaping ([Article] ) -> Void) {
        let miCompletionHandler = {(response: DataResponse<Any>)-> Void in
            
            var dictionaryArray : [[String:AnyObject]] = [[:]]
            if let userDefaultValue = UserDefaults.standard.array(forKey: "savedNews"){
                dictionaryArray = userDefaultValue as! [[String : AnyObject]]
            }
            var resultArray : [Article] = []
            if let json = response.result.value as? [String: AnyObject] {
                if let articles = json["articles"] as? [[String:AnyObject]]{
                    
                    for article in articles {
                        let myArticle = Article(with: article)
                        for d in dictionaryArray{
                            if myArticle.getTitle() == d["title"] as! String?{
                                myArticle.isSaved = true
                                break
                            }
                        }
                        resultArray.append(myArticle)
                        
                    }
                    completionHandler(resultArray)
                }
                //}
            }
        }
            let newFromSource = NewsHelper.getEverythingPorFuente(idFuente: sourceId)
			Alamofire.request(newFromSource).responseJSON(completionHandler: miCompletionHandler)
    }
	
	func searchArticlesByQuery(_ query: String, completion: @escaping ([Article]) -> Void) {
		
		Alamofire.request(NewsHelper.getEverythingPorConsulta(searchQuery: query)).responseJSON { (response) in
			
			if let mainDictionary = response.result.value as? [String: AnyObject] {
				if let results = mainDictionary["articles"] as? [[String: AnyObject]] {
					var articlesArray: [Article] = []
					for aDictionary in results {
						let newArticle = Article(with: aDictionary)
						articlesArray.append(newArticle)
					}
					completion(articlesArray)
				} else {
					completion([])
					print("Error retrieving articles")
				}
			}
			
		}
	}
	
	//MARK:- TEST
func fetchArticlesByQuery(_ query: String, completion: @escaping ([Article]) -> Void){
		print("Searching for articles...")
	
	Alamofire.request(NewsHelper.getEverythingPorConsulta(searchQuery: query), method: .get, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
			
			if let err = dataResponse.error {
				print("Failed to contact webserver", err)
				return
			}
			
			guard let data = dataResponse.data else { return }
			do {
				let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
				completion(searchResult.results)
			} catch let decodeErr {
				print("Failed to decode:", decodeErr)
			}
		}
	}
	
	func fetchArticlesByQueryAndDate(_ query: String, from: Date, to: Date, completion: @escaping ([Article]) -> Void ) {
		
		var localTimeZoneAbbreviation: String { return  NSTimeZone.local.abbreviation(for: Date())! }

		let currentDate = Calendar.current
		var twentyFour = currentDate.date(byAdding: .day, value: -1, to: Date())
		var fourtyEight = currentDate.date(byAdding: .day, value: -2, to: Date())
		var lastWeek = currentDate.date(byAdding: .day, value: -7, to: Date())
		var lastTwoWeeks = currentDate.date(byAdding: .day, value: -14, to: Date())
		
		Alamofire.request("https://newsapi.org/v2/everything?q=\(query))&from=\(from)&to=\(to)apikey=142b284b913041e2a2523e7faaf1120c").responseData { (dataResponse) in
			if let error = dataResponse.error {
				print("Failed to contact webserver: ", error)
				return
			}
			
			guard let data = dataResponse.data else { return }
			do {
				let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
				completion(searchResult.results)
			} catch let decodeError {
				print("Failed to decode: ", decodeError)
			}
		}
		
	}
	
	struct SearchResults: Decodable {
		let resultCount: Int
		let results: [Article]
	}
	//MARK:- TEST
    
//    func saveNews (_ article : Article){
//
//        var dictionaryArray : [[String:AnyObject]] = [[:]]
//
//        ref.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
//            if let dictionary = snapshot.value as? NSDictionary{
//                if let array = dictionary.allValues as? [[String:AnyObject]]{
//                    dictionaryArray = array
//                }
//            }
//        article.isSaved = true
//
//        dictionaryArray.append(article.toDictionary())
//
//
//        UserDefaults.standard.set(dictionaryArray, forKey: "savedNews")
//        }
//    }
//
//    func returnSavedArticles() -> [Article] {
//
//        var dictionaryArray : [[String:AnyObject]] = [[:]]
//
//        ref.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
//            if let dictionary = snapshot.value as? NSDictionary{
//                if let array = dictionary.allValues as? [[String:AnyObject]]{
//                    dictionaryArray = array
//                }
//            }
//
//        var articlesArray : [Article] = []
//
//        for a in dictionaryArray{
//
//            articlesArray.append(Article(with: a))
//        }
//        return articlesArray
//    }
//
//    func removeAnArticle(_ article : Article) {
//        article.isSaved = false
//        var dictionaryArray : [[String:AnyObject]] = [[:]]
//
//    ref.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
//            if let dictionary = snapshot.value as? NSDictionary{
//                if let array = dictionary.allValues as? [[String:AnyObject]]{
//                    dictionaryArray = array
//                }
//            }
//        var index = 0
//        for a in dictionaryArray{
//            if  a["title"] as! String? == article.getTitle(){
//                dictionaryArray.remove(at: index)
//                break
//            }else{
//                index = index + 1
//            }
//        }
//        for a in dictionaryArray{
//            self.ref.child(theID).child(theEmail).child(a["title"]).setValue(a)
//        }
//        }
//
//    }

//    func readFromDatabase() -> [[String:AnyObject]] {
//        ref.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
//            if let dictionary = snapshot.value as? NSDictionary{
//                if let array = dictionary.allValues as? [[String:AnyObject]]{
//
//                    myDictionaryArray = array
//
//                }
//            }
//
//        }
//    }
    func SaveArticleInDB(_ article: Article){
        
        var dictionaryArray : [[String:AnyObject]] = [[:]]
        self.ref.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? NSDictionary{
                    if let array = dictionary.allValues as? [[String:AnyObject]]{
                        dictionaryArray = array
                        
                    }
                }
            article.isSaved = true
            dictionaryArray.append(article.toDictionary())
            dictionaryArray.remove(at: 0)
            //print(d["title"])
            print(self.ref)
            for d in dictionaryArray{
                self.ref.child((Auth.auth().currentUser?.uid)!).child(d["title"] as! String).setValue(d)
            }
        }
    }
    
    func getSavedArticles(completionHandler: @escaping ([Article] ) -> Void){
        var dictionaryArray : [[String:AnyObject]] = [[:]]
        self.ref.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? NSDictionary{
                    if let array = dictionary.allValues as? [[String:AnyObject]]{
                        dictionaryArray = array
                        
                    }
                }
                var articlesArray : [Article] = []
                for a in dictionaryArray{
                    articlesArray.append(Article(with: a))
                }
            completionHandler(articlesArray)
        }
    }
    
    func removeArticleFromDB(_ article: Article){
        ref.child((Auth.auth().currentUser?.uid)!).child(article.getTitle()).removeValue()
    }
    
    
    
    
}
