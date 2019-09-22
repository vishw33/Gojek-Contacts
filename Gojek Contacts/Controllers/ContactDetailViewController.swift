//
//  ContactDetailViewController.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    var contactId:String = ""
    var detailModel:DetailContact?
    var baseMissingURl = "https://gojek-contacts-app.herokuapp.com/images/missing.png"
    let placeHolderImg = UIImage(named: "placeholder_photo")
    
    var infoArray = ["Mobile" , "email"]
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.traitCollection.userInterfaceStyle == .dark {
            baseMissingURl = ""
        } else {
            baseMissingURl = "https://gojek-contacts-app.herokuapp.com/images/missing.png"
        }
        detailTable.alwaysBounceVertical = false
        detailTable.tableFooterView = UIView(frame: CGRect.zero)
        fetchDetail()
    }
    
    func fetchDetail(){
        API.shared.getDetails(with: SessionAPIRequest.FetchContactDetail(id: contactId)) { (detail, err) in
            self.detailModel = detail
            DispatchQueue.main.async {
                self.setupView()
            }
        }
    }
    
    func setupView()  {
        guard let model = detailModel else { return}
        let fName = model.firstName ?? ""
        let lName = model.lastName ?? ""
        let url:String = model.profilePic == "/images/missing.png" ? baseMissingURl : model.profilePic!
        nameLabel.text = fName + " " + lName
        profileImage.image = placeHolderImg
        profileImage.downloadImageFrom(link: url, contentMode: .scaleAspectFit)
        detailTable.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setGradient()
    }
    
    func setGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(white: 1, alpha: 0.9), UIColor(red: 53/255.0, green: 255/255.0, blue: 250/255.0, alpha: 1).cgColor]
        gradient.frame = self.headerView.layer.frame
        self.headerView.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension ContactDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailCell
        cell.infoLabel.text = infoArray[indexPath.row]
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.detailLabel.text = detailModel?.phoneNumber ?? "+00 000000"
        case 1:
            cell.detailLabel.text = detailModel?.email ?? "example@go.com"
        default:
            print(detailModel as Any)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    
}
