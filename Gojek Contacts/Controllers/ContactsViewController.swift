//
//  ContactsViewController.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import UIKit

protocol ContactProtocal {
    func Update()
}

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var contactTableView: UITableView!
    var modelArray = [ContactsModel]()
    let favImage = UIImage(named: "home_favourite")
    let placeHolderImg = UIImage(named: "placeholder_photo")
    let activity = UIActivityIndicatorView(style: .large)
    var groupedContacts = [String: [ContactsModel]]()
    var keysSorted = [String]()
    var baseMissingURl = "https://gojek-contacts-app.herokuapp.com/images/missing.png"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpActivity()
        self.title = "Contacts"
        if self.traitCollection.userInterfaceStyle == .dark {
            baseMissingURl = ""
        } else {
           baseMissingURl = "https://gojek-contacts-app.herokuapp.com/images/missing.png"
        }
        contactTableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        fetchContacts()
        
        let addBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addAction))
        self.navigationItem.rightBarButtonItem  = addBarButtonItem
    }
    
    @objc func addAction(){
         let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NewContactViewController") as! NewContactViewController
        vc.mode = .New
        vc.delegate = self
        let presentNav = UINavigationController(rootViewController: vc)
        self.navigationController?.present(presentNav, animated: true, completion: nil)
    }
    
    func setUpActivity()  {
        activity.center = self.view.center
        self.view.addSubview(activity)
    }
    
    func fetchContacts() {
        activity.startAnimating()
        contactList.shared.getUpdatedContact { (isComplete) in
            if isComplete {
                self.modelArray = contactList.shared.contactListCollection
                DispatchQueue.main.async {
                    self.modelArray.sort{$0.firstName! < $1.firstName!}
                    self.groupContacts() 
                    self.contactTableView.reloadData()
                    self.activity.stopAnimating()
                }
            } else {
                self.showErrorAlert(message: "Something is wrong please Try After Sometime")
            }
        }
    }
    
    func groupContacts()  {
        for contact in self.modelArray {
            let alph = String(contact.firstName!.prefix(1)).uppercased()
                if var contactSubArray = groupedContacts[alph] {
                    contactSubArray.append(contact)
                    groupedContacts[alph] = contactSubArray
                } else {
                    groupedContacts[alph] = [contact]
                }
        }
        
        keysSorted = groupedContacts.keys.sorted()
    }
}

extension ContactsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let char = keysSorted[section]
        if let contactModel = groupedContacts[char] {
            return contactModel.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keysSorted[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keysSorted
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let model:ContactsModel =  groupedContacts[keysSorted[indexPath.section]]![indexPath.row]
        cell.nameLabel.text = model.firstName ?? ""
        cell.selectionStyle = .none
        cell.favImage.isHidden =  !(model.favorite ?? false)
        cell.profileImage?.image = placeHolderImg
        let url:String = model.profilePic == "/images/missing.png" ? baseMissingURl : model.profilePic!
        cell.profileImage.downloadImageFrom(link: url, contentMode: .scaleAspectFit)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model:ContactsModel = self.modelArray[indexPath.row]
            guard let contactId:Int = model.id else {return}
            activity.startAnimating()
            API.shared.deleteContact(with: SessionAPIRequest.DeleteContact(id: "\(contactId)")) { (isSuccess, val) in
                if isSuccess {
                    DispatchQueue.main.async {
                        self.groupedContacts[self.keysSorted[indexPath.section]]?.remove(at: indexPath.row)
                        self.modelArray.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        self.activity.stopAnimating()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ContactDetailViewController
        let model:ContactsModel? =  groupedContacts[keysSorted[indexPath.section]]?[indexPath.row]
        guard let pickedModel = model?.id else {
            return
        }
        let id:String = "\(pickedModel)"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        vc.contactId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ContactsViewController:ContactProtocal {
    func Update() {
        fetchContacts()
    }
}
