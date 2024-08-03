//
//  ScoreTableViewCell.swift
//  StationTravel
//
//  Created by 亀川敦躍 on 2024/07/27.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    @IBOutlet var stationLabel : UILabel!
    @IBOutlet var pointLabel : UILabel!
    @IBOutlet var DateLabel : UILabel!

    func setCell(station: String, point: Int, Date: String) {
        stationLabel.text = station
        pointLabel.text = String(point)
        DateLabel.text = Date
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
