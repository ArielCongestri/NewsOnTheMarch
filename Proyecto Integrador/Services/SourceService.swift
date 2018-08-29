//
//  File.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 30/5/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import Foundation
import Alamofire

class SourcesServices {
	
    
    func getSources () -> [Source]{
        var sources : [Source] = []
        let data = PlistManager.readDictionary(name: "sources")
        let sourcesArray :[[String:AnyObject]]  = data["sources"] as! [[String : AnyObject]]
        
        for s in sourcesArray{
            let newSource = Source(dictionary: s)
            sources.append(newSource)
        }
        
        return sources
    }
	
    func getSourcesFromAPI(completionHandler: @escaping ([[Source]]) -> Void) {
        SourceDAO().fetchSources { (sources: [Source]) in

            var finalSources : [[Source]] = [[]]
            var sourcesFavoriteSeccion : [Source] = []
            var sourcesOtherSeccion : [Source] = []
            let favoritesSources = SourceDAO().returnSavedSources()
            for s in sources{
                var found = false
                for fs in favoritesSources{
                    if s.getId() == fs.getId(){
                        found = true
                        break
                    }
                }
                if found{
                    s.isSaved = true
                    sourcesFavoriteSeccion.append(s)
                } else {
                    sourcesOtherSeccion.append(s)
                }
            }

            finalSources.remove(at: 0)
            finalSources.append(sourcesFavoriteSeccion)
            finalSources.append(sourcesOtherSeccion)

            completionHandler(finalSources)
        }
    }
    func saveSource(_ source: Source){
        let aNewsDAO = SourceDAO()
        aNewsDAO.save(source: source)
    }
    
    func removeASource(_ source: Source){
        
        let aNewsDAO = SourceDAO()
        aNewsDAO.removeASource(source)
    }
    
    func entireFilter(source: [[Source]], withCategories : [String], search : String?
        ) ->[[Source]]{
        var filteredSources = source
        
        if let search = search {
            filteredSources[0] = search.isEmpty ? source[0] : source[0].filter ({ Source0 -> Bool in
                Source0.getName().lowercased().contains(search.lowercased())||Source0.getCategory().lowercased().contains(search.lowercased())
                
            })
            
            filteredSources[1] = search.isEmpty ? source[1] : source[1].filter ({ Source1 -> Bool in
                
                Source1.getName().lowercased().contains(search.lowercased())||Source1.getCategory().lowercased().contains(search.lowercased())
                
            })
        }
        
        
        return self.filter(source: filteredSources, withCategories: withCategories)
    }
    
    
    
    
    func filter(source: [[Source]], withCategories : [String]) ->[[Source]]{
        var filteredArray : [[Source]] = []
        let sourceFavorited : [Source] = source[0]
        let sourceOther : [Source] = source[1]
        var filteredFavorited : [Source] = []
        var filteredOther : [Source] = []
        
        for s in sourceFavorited{
            for c in withCategories{
                if c == s.getCategory(){
                    filteredFavorited.append(s)
                    break
                }
            }
        }
        for s in sourceOther{
            for c in withCategories{
                if c == s.getCategory(){
                    filteredOther.append(s)
                    break
                }
            }
        }
        
        filteredArray.append(filteredFavorited)
        filteredArray.append(filteredOther)
        
        return filteredArray
    }
    

}


