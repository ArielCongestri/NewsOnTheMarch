//
//  SourcesDAO.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 29/6/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import Foundation
import Alamofire

class SourceDAO {
    
    func fetchSources(completionHandler: @escaping ([Source] ) -> Void) {
        let sourceFromAPI = NewsHelper.getFuentesPorIdioma(idioma: NewsHelper.language_INGLES)

        var sources : [Source] = []
        Alamofire.request(sourceFromAPI).responseJSON { (dataResponse) in
            
            if let data = dataResponse.result.value as? [String:AnyObject]{
                
                let sourcesArray :[[String:AnyObject]]  = data["sources"] as! [[String : AnyObject]]
                
                for s in sourcesArray{
                    let newSource = Source(dictionary: s)
                    sources.append(newSource)
                }
                
                completionHandler(sources)
            }
        }
    }
    
    func save(source: Source){
        var dictionaryArray : [[String:AnyObject]] = [[:]]
        
        if let userDefaultValue = UserDefaults.standard.array(forKey: "savedSources"){
            dictionaryArray = userDefaultValue as! [[String : AnyObject]]
        }
        
        dictionaryArray.append(source.toDictionary())
        
        
        UserDefaults.standard.set(dictionaryArray, forKey: "savedSources")
    }
    
    func returnSavedSources() -> [Source] {

        var dictionaryArray : [[String:AnyObject]] = [[:]]

        if let userDefaultValue = UserDefaults.standard.array(forKey: "savedSources"){
            dictionaryArray = userDefaultValue as! [[String : AnyObject]]
        }

        var sourcesArray : [Source] = []

        for s in dictionaryArray{

            sourcesArray.append(Source(dictionary: s))
        }
        return sourcesArray
    }
    
    func removeASource(_ source : Source) {
        source.isSaved = false
        var dictionaryArray : [[String:AnyObject]] = [[:]]
        
        if let userDefaultValue = UserDefaults.standard.array(forKey: "savedSources"){
            dictionaryArray = userDefaultValue as! [[String : AnyObject]]
        }
        var index = 0
        for a in dictionaryArray{
            if  a["id"] as! String? == source.getId(){
                dictionaryArray.remove(at: index)
                break
            }else{
                index = index + 1
            }
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "savedSources")
    }

}


