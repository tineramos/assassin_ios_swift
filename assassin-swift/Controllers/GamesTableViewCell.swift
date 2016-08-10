//
//  GamesTableViewCell.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 06/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class GamesTableViewCell: UITableViewCell {

    @IBOutlet weak var gameTitle: UILabel?
    @IBOutlet weak var gameStatus: UILabel?
    @IBOutlet weak var players: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(game: Game) {
        gameTitle?.text = game.game_title
        gameStatus?.text = game.game_status
        players?.text = game.getPlayerTitle()
    }
    
}
