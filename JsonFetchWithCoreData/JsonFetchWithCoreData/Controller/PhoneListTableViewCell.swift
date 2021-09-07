//
//  PhoneListTableViewCell.swift
//  JsonFetchWithCoreData
//
//  Created by Nilesh Vernekar on 07/09/21.
//

import UIKit

class PhoneListTableViewCell: UITableViewCell {
    static let cellIdentifier = "PhoneListTableViewCell"
    static let xibName = "PhoneListTableViewCell"
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellData(data: UserDataModel?)
    {
        self.nameLbl.text = data?.name
        self.phoneLbl.text = data?.phone
    }
    
}
