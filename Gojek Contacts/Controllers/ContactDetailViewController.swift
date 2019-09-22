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
    
    let activity = UIActivityIndicatorView(style: .large)
    
    var infoArray = ["Mobile" , "email"]
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.traitCollection.userInterfaceStyle == .dark {
            baseMissingURl = ""
        } else {
            baseMissingURl = "https://gojek-contacts-app.herokuapp.com/images/missing.png"
        }
        let editBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editAction))
        self.navigationItem.rightBarButtonItem  = editBarButtonItem
        detailTable.alwaysBounceVertical = false
        detailTable.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDetail()
    }
    
    @objc func editAction(){
         let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NewContactViewController") as! NewContactViewController
        vc.mode = .Edit
        vc.detailModel = detailModel
        vc.delegate = self
        let presentNav = UINavigationController(rootViewController: vc)
        self.navigationController?.present(presentNav, animated: true, completion: nil)
        
    }
    
    func setUpActivity()  {
           activity.center = self.view.center
           self.view.addSubview(activity)
       }
    
    func fetchDetail(){
        activity.startAnimating()
        API.shared.getDetails(with: SessionAPIRequest.FetchContactDetail(id: contactId)) { (detail, err) in
            if err == nil {
                DispatchQueue.main.async {
                               self.detailModel = detail
                               self.setupView()
                               self.activity.stopAnimating()
                           }
            }else {
                self.showErrorAlert(message: "Please Try After Sometime")
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
        self.headerView.setGradient()
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

extension ContactDetailViewController:ContactProtocal{
    func Update() {
        fetchDetail()
    }
}
