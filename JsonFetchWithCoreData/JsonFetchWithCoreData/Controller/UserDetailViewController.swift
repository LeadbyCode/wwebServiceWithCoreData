//
//  UserDetailViewController.swift
//  JsonFetchWithCoreData
//
//  Created by Nilesh Vernekar on 07/09/21.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var emailid: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    
    var userDetail : UserDataModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        dataLoad()
        self.idLbl.layer.cornerRadius = 15
        self.idLbl.layer.borderWidth = 1
        self.idLbl.layer.backgroundColor = .init(red: 3, green: 237, blue: 255, alpha: 1)
        self.backBtn.layer.cornerRadius = 5
        self.backBtn.layer.borderWidth = 1
        self.backBtn.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ackbtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func dataLoad()  {
        self.idLbl.text = userDetail?.id?.description ?? "0"
        self.nameLbl.text = "Name: " + (userDetail?.name ?? "")
        self.emailid.text = "Email: " + (userDetail?.email ?? "")
        self.userNameLbl.text = "UserName: " + (userDetail?.username ?? "")
        self.phone.text = "Phone: " + (userDetail?.phone ?? "")
        self.websiteLbl.text = "Website: " + (userDetail?.website ?? "")
        self.companyLbl.text = "Company: " + (userDetail?.company?.name ?? "")
        let pin = ", " + (userDetail?.address?.zipcode ?? "")
        let city = ", " + (userDetail?.address?.city ?? "")
        let suite = ", " + (userDetail?.address?.suite ?? "")
        let add = suite + city + pin
        self.address.text = "Address: " + (userDetail?.address?.street ?? "") + add
    }

}
