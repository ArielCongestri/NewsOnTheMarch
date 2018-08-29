//
//  SourcesTableViewCell.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 30/5/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit

class SourcesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var saveSourceButton: UIButton!
	
    var saveSourceDelegate: SaveSourceDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    public func setupWith(_ source: Source, delegate: SaveSourceDelegate) {
        saveSourceButton.isHidden = false
        saveSourceDelegate = delegate
        sourceLabel.text = source.getName()
        descriptionLabel.text = source.getDescription()
        
        if source.isSaved {
            
            saveSourceButton.setImage(UIImage(named: "readLaterBlack"), for: .normal)
        } else {
            saveSourceButton.setImage(UIImage(named: "readLater"), for: .normal)
        }
    }
    
    @IBAction func savesourceButtonPressed(_ sender: UIButton) {
        saveSourceDelegate?.toggleSaveSource(cell: self)
    }
	
    
}
