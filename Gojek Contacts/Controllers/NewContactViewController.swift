//
//  NewContactViewController.swift
//  Gojek Contacts
//
//  Created by Vishwas on 22/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import UIKit
enum ViewMode {
    case Edit
    case New
}

class NewContactViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    var infoArray = ["FirstName","LastName","Mobile" , "email"]
    var originalViewRect: CGRect?
    var fname:String = ""
    var lname:String = ""
    var phone:String = ""
    var email:String = ""
    
    let activity = UIActivityIndicatorView(style: .large)
    var delegate:ContactProtocal?
    
    var detailModel:DetailContact?
    var mode:ViewMode = .New
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseMissingURl =  self.traitCollection.userInterfaceStyle == .dark ? "" : "https://gojek-contacts-app.herokuapp.com/images/missing.png"
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        self.navigationItem.rightBarButtonItem  = doneBarButtonItem
        
        let dismissBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissAction))
        self.navigationItem.leftBarButtonItem  = dismissBarButtonItem
        setUpActivity()
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewContactViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewContactViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func ShowErr(str:String) {
        showErrorAlert(message:str)
    }
    
    @objc func dismissAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpActivity()  {
        activity.center = self.view.center
        self.view.addSubview(activity)
    }
    
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @objc func doneAction(){
        self.view.endEditing(true)
        
        if fname.count > 0{
            if !(phone.count >= 10){
                ShowErr(str: "Enter Valid phone Number")
                return
            }
        }else {
            ShowErr(str: "Enter First Name")
            return
        }
        var dict = Dictionary<String, Any>()
        dict["first_name"] = fname
        dict["last_name"] = lname
        dict["email"] = email
        dict["phone_number"] = phone
        dict["favorite"] = true
        
        activity.startAnimating()
        if mode == .Edit {
            guard let myModel = detailModel else {
                return
            }
            let id:String = "\(myModel.id ?? 0)"
            API.shared.updateContact(with: SessionAPIRequest.UpdateContact(id: id, parameter: dict)) { (isDone,err)  in
                if isDone {
                    DispatchQueue.main.async {
                        self.activity.stopAnimating()
                        self.delegate?.Update()
                        self.showAlert(message: "Contact Updated Successfully")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.activity.stopAnimating()
                        self.showAlert(message: "Some thing Went Wrong Please Try after Sometime")
                    }
                }
            }
        } else {
            API.shared.saveContact(with: SessionAPIRequest.AddNewContact(parameter: dict)) { (isDone,err) in
                if isDone {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Contact Added Successfully")
                        self.delegate?.Update()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Couldn't add Contact at this time, Please try After sometime")
                    }
                }
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.setGradient()
        profileImage.setRounded()
        self.originalViewRect = self.view.frame
        if (mode == .Edit) {
            setupView()
            self.title = "Edit Contact"
            self.nameLabel.isHidden = false
            self.cameraButton.isHidden = true
        }else {
            self.title = "New Contact"
            self.nameLabel.isHidden = true
            self.cameraButton.isHidden = false
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == self.originalViewRect?.origin.y {
            if view.frame.height <= 568 {
                self.view.frame.origin.y -= 200
            }
            else {
                self.view.frame.origin.y -= 130
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != self.originalViewRect?.origin.y {
                self.view.frame.origin.y = (self.originalViewRect?.origin.y)!
            }
        }
    }
}

extension NewContactViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as! DetailEditCell
        cell.infoLabel.text = infoArray[indexPath.row]
        cell.detailInfoTextField.delegate = self
        cell.detailInfoTextField.tag = indexPath.row + 100
        cell.selectionStyle = .none
        if mode == .Edit {
            switch indexPath.row {
            case 0:
                cell.detailInfoTextField.text = detailModel?.firstName ?? ""
                fname = detailModel?.firstName ?? ""
            case 1:
                cell.detailInfoTextField.text = detailModel?.lastName ?? ""
                lname = detailModel?.lastName ?? ""
            case 2:
                cell.detailInfoTextField.text = detailModel?.phoneNumber ?? "+00 0000000000"
                cell.detailInfoTextField.keyboardType = .namePhonePad
                phone = detailModel?.phoneNumber ?? "+00 0000000000"
            case 3:
                cell.detailInfoTextField.text = detailModel?.email ?? "example@go.com"
                cell.detailInfoTextField.keyboardType = .emailAddress
                email = detailModel?.email ?? "example@go.com"
            default:
                print(detailModel as Any)
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}

extension NewContactViewController:UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 100:
            fname = textField.text ?? ""
        case 101:
            lname = textField.text ?? ""
        case 102:
            phone = textField.text ?? ""
        case 103:
            email = textField.text ?? ""
        default:
            print(textField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewContactViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               profileImage.contentMode = .scaleAspectFit
               profileImage.image = pickedImage
           }
           dismiss(animated: true, completion: nil)
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
       }
}


