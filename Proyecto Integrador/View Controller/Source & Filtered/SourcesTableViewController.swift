//
//  SourcesTableViewController.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 30/5/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit

protocol SaveSourceDelegate {
    func updateSavedSource(_ source: Source)
    func toggleSaveSource(cell: UITableViewCell)
}



class SourcesTableViewController: UITableViewController, UISearchBarDelegate, SaveSourceDelegate,FilterDelegate  {

    func updateSavedSource(_ source: Source) {

    }
    
    func toggleSaveSource(cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            
            let source = filteredSources[indexPath.section][indexPath.row]
            
            let indexPathOptional = SearchInSources(source: source)
            
            if let indexPath2 = indexPathOptional{
                let source2 = sources[indexPath2.section][indexPath2.row]

                if source.isSaved{
                    filteredSources[indexPath.section].remove(at: indexPath.row)
                    sources[indexPath2.section].remove(at: indexPath2.row)
                    if indexPath.section == 0{
                        filteredSources[1].append(source)
                        sources[1].append(source2)
                    }else{
                        filteredSources[0].append(source)
                        sources[0].append(source2)
                    }
                    mySourceService.removeASource(source)
                    source.isSaved = false
                }else{
                    filteredSources[indexPath.section].remove(at: indexPath.row)
                    sources[indexPath2.section].remove(at: indexPath2.row)
                    if indexPath.section == 0{
                        filteredSources[1].append(source)
                        sources[1].append(source2)
                        
                    }else{
                        filteredSources[0].append(source)
                        sources[0].append(source2)
                    }
                    mySourceService.saveSource(source)
                    source.isSaved = true
                }
                
                filteredSources[0].sort { (a, b) -> Bool in
                    return a.getName() < b.getName()
                }
                filteredSources[1].sort { (a, b) -> Bool in
                    return a.getName() < b.getName()
                }
                sources[0].sort { (a, b) -> Bool in
                    return a.getName() < b.getName()
                }
                sources[1].sort { (a, b) -> Bool in
                    return a.getName() < b.getName()
                }
                tableView.reloadData()

            }
        }
    }
	
	let searchController = UISearchController(searchResultsController: nil)
    var mySourceService : SourcesServices = SourcesServices()
    var sources : [[Source]] = [[]]
    var filteredSources :  [[Source]] = [[]]
    var selectedCategories : [String] = ["science","entertainment","sports","Technology","general","health","business"]
    
//	@IBOutlet weak var searchBar: UISearchBar! {
//	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySourceService.getSourcesFromAPI { (sourcesArray) in
            
            self.sources = sourcesArray
            self.filteredSources = self.sources
            self.tableView.reloadData()
        }
		
		self.setupSearchBar()
        filteredSources = sources
		self.tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SourceCell", bundle: nil), forCellReuseIdentifier: "sourceTableViewCell")
        
    }
	
	fileprivate func setupSearchBar() {
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
		searchController.searchBar.showsCancelButton = true
		searchController.searchBar.placeholder = "Search articles..."
		definesPresentationContext = true
		
		searchController.searchBar.tintColor = .white
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // funcion del la searchBar que se ejecuta cada vez que colocamos el texto
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
        self.filteredSources = mySourceService.entireFilter(source: sources, withCategories: selectedCategories, search: searchText)
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return filteredSources.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredSources[section].count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sourceTableViewCell", for: indexPath)
        
        if let savedCell = cell as? SourcesTableViewCell{
            savedCell.setupWith(filteredSources[indexPath.section][indexPath.row], delegate: self)
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FilteredArticlesTableViewController {
            if let selectedSource = tableView.indexPathForSelectedRow {
                destination.sourceId = filteredSources[selectedSource.section][selectedSource.row].getId()
                
            }
        }
        if let filterDestination = segue.destination as? SortCategoryViewController{
            filterDestination.myDelegate = self

        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        self.filteredSources = self.sources
        self.tableView.reloadData()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detailSource", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if filteredSources[0].count == 0{
                return nil
				
            } else {
                return "Favorites"
            }
        } else {
            return "All Sources"
        }
		
    }
	
	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		guard let header = view as? UITableViewHeaderFooterView else { return }
		header.textLabel?.textColor = UIColor.darkGray
		header.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
		header.textLabel?.frame = header.frame
		header.textLabel?.textAlignment = .center
		header.backgroundView?.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 1)
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return self.filteredSources.count > 0 ? 50 : 0

	}
    
    func setFilter(selectedCategories: [String]) {
        self.selectedCategories = selectedCategories
        filteredSources = sources
        tableView.reloadData()
         filteredSources = mySourceService.filter(source: filteredSources, withCategories: selectedCategories)
        tableView.reloadData()
    }
    
    func SearchInSources(source: Source) -> IndexPath?{
        var indexpath = IndexPath(row: 0, section: 0)
        var indexFavorited = 0
        var indexOther = 0
        
        
        for s in sources[0]{
            if s.getId() == source.getId(){
                
                indexpath = IndexPath(row: indexFavorited, section: 0)
            }
            indexFavorited = indexFavorited + 1
        }
        for s in sources[1]{
            if s.getId() == source.getId(){
                
                indexpath = IndexPath(row: indexOther, section: 1)
            }
            indexOther = indexOther + 1
        }
        return indexpath
    }
    

}

