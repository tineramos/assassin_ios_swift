//
//  PlayersTableViewCell.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 08/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class PlayersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var codeNameLabel: UILabel?
    @IBOutlet weak var killsCountLabel: UILabel?
    @IBOutlet weak var isEliminatedLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithPlayer(player: Player) {
        
        codeNameLabel?.text = player
        
    }

}
