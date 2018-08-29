//
//  Article
//  Proyecto Integrador
//
//  Created by VictorCh on 23/05/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import Foundation


class Article: Decodable {
    
    
    private var title: String
    private var author: String
    private var description: String
    private var url: String
    private var urlToImage: String
    private var publishedAt: String
    var isSaved: Bool = false
    private var source: Source?
    
    
    public init(title: String,
                author: String,
                description: String,
                url: String,
                urlToImage: String,
                publishedAt: String,
                source: Source) {
        
        self.title = title
        self.author = author
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.source = source
        
        
    }
    
    init(with dictionary: [String: AnyObject]) {
        self.title = dictionary["title"] as? String ?? "titleNotSet"
        self.author = dictionary["author"] as? String ?? "authorNotSet"
        self.description = dictionary["description"] as? String ?? "noDescription"
        self.url = dictionary["url"] as? String ?? "noURL"
        self.urlToImage = dictionary["urlToImage"] as? String ?? "noImage"
        self.publishedAt = dictionary["publishedAt"] as? String ?? "notSet"
        let aSource = dictionary["source"] as? [String : AnyObject]
		if let sourceValue = aSource {
        self.source = Source(dictionary: sourceValue)
		}
        self.isSaved = dictionary["isSaved"] as? Bool ?? false
        
    }
    
    public func getTitle() -> String {
        return title
    }
    
    public func getDescription() -> String {
        return description
    }
    
    public func getPublishedAt() -> String {
        return publishedAt
    }
    
    public func getAuthor() -> String {
        return author
    }
    
    public func getUrlToImage() -> String {
        return urlToImage
    }
    
    public func getSource() ->Source{
		if let mySource = source {
			return mySource
		} else {
			return Source(id: "noId", name: "noName", description: "noDesc", category: "noCat")
		}
    }
	
	public func getDate() -> Date? {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
		return dateFormatter.date(from: getPublishedAt())
	}

    
    func getUrl() -> String {
        return url
    }
    
    func toDictionary() -> [String:AnyObject]{
        var article: [String:AnyObject] = [:]
        
        article["title"] = self.title as AnyObject
        article["description"] = self.description as AnyObject
        article["urlToImage"] = self.urlToImage as AnyObject
        article["url"] = self.url as AnyObject
        article["isSaved"] = self.isSaved as AnyObject
        article["publishedAt"] = self.publishedAt as AnyObject
        article["source"] = self.source?.toDictionary() as AnyObject
        
        return article
    }
    
    
    
}
