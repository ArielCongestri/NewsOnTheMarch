//
//  SortCategoryViewController.swift
//  Proyecto Integrador
//
//  Created by Victor Chang on 29/06/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit

class SortCategoryViewController: UIViewController {

    @IBAction func SaveTapped(_ sender: Any) {
        apendSelecteds()
        myDelegate?.setFilter(selectedCategories: selectedCategories)
        navigationController?.popViewController(animated: true)
        
    }
    @IBOutlet weak var BusinessSwitch: UISwitch!
    @IBOutlet weak var generalSwitch: UISwitch!
    @IBOutlet weak var TechnologySwitch: UISwitch!
    @IBOutlet weak var SportsSwitch: UISwitch!
    @IBOutlet weak var ScienceSwitch: UISwitch!
    @IBOutlet weak var HealthSwitch: UISwitch!
    @IBOutlet weak var EntertainmentSwitch: UISwitch!
	@IBOutlet weak var saveButton: UIButton! {
		didSet {
			saveButton.layer.cornerRadius = 5
		}
	}
	
	
    var myDelegate : FilterDelegate?
    var selectedCategories : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func apendSelecteds(){
        selectedCategories = []
        if BusinessSwitch.isOn{
            selectedCategories.append("business")
        }
        if HealthSwitch.isOn{
            selectedCategories.append("health")
        }
        if generalSwitch.isOn{
            selectedCategories.append("general")
        }
        if TechnologySwitch.isOn{
            selectedCategories.append("Technology")
        }
        if SportsSwitch.isOn{
            selectedCategories.append("sports")
        }
        if EntertainmentSwitch.isOn{
            selectedCategories.append("entertainment")
        }
        if ScienceSwitch.isOn{
            selectedCategories.append("science")
        }
        
        
    }

}
