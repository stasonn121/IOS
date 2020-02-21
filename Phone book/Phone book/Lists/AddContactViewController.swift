//
//  AddContact.swift
//  Phone book
//
//  Created by user on 13.02.2020.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {

    // MARK: - Public variables
    @IBOutlet weak var addInformationTableView: UITableView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var savedButton: UIBarButtonItem!
    var human: Contact? = Contact()
    var createContact: Bool?
    let imagePicker = UIImagePickerController()
    // MARK: - Private variables
    private var firstSectionCounter = 1
    private var secondSectionCounter = 1
    private var counter = 0
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        savedButton.isEnabled = false
        configureTableView()
    }
    
    // MARK: - Configure
    private func configureTableView() {
        contactImage.image = human?.photo
        contactImage.layer.cornerRadius = contactImage.bounds.width / 2
        imagePicker.delegate = self
        addInformationTableView.dataSource = self
        addInformationTableView.delegate = self
        addInformationTableView.register(UINib(nibName: String(describing: TestTableViewCell.self), bundle: nil),
                                         forCellReuseIdentifier: UIConstants.CellIdentifiers.myCellId)
        addInformationTableView.register(UINib(nibName: String(describing: NumberEmailTableViewCell.self), bundle: nil),
                                         forCellReuseIdentifier: UIConstants.CellIdentifiers.numberEmailId)
        addInformationTableView.register(UINib(nibName: String(describing: TelephoneTableViewCell.self), bundle: nil),
                                         forCellReuseIdentifier: UIConstants.CellIdentifiers.deleteCellId)
    }
    // MARK: - Actions
   
    @IBAction func addPhoto(_ sender: Any) {
        let alert = UIAlertController(title: "Image", message: nil, preferredStyle: .actionSheet)
        
        let actionPhoto = UIAlertAction(title: "Galery", style: .default) { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (alert) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let actionCencel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actionPhoto)
        alert.addAction(actionCamera)
        alert.addAction(actionCencel)
        
        present(alert, animated: true, completion: nil)
    }
}
    // MARK: - UITableViewDataSource, UITableViewDelegate
    extension AddContactViewController : UITableViewDataSource, UITableViewDelegate
    {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch section {
            case 0:
                return 3
            case 1:
                return firstSectionCounter
            case 2:
                return secondSectionCounter
            default:
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.CellIdentifiers.myCellId) as! TestTableViewCell
            
                switch indexPath.row {
                case 0:
                    cell.textField?.placeholder = "First name"
                case 1:
                    cell.textField?.placeholder = "Last name"
                case 2:
                    cell.textField?.placeholder = "Company"
                default:
                    break
                }
                cell.textField.delegate = self
                
                return cell
            }
            if indexPath.row == 0 && indexPath.section == 1 && firstSectionCounter == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.CellIdentifiers.numberEmailId) as! NumberEmailTableViewCell
                
                cell.informationLabel?.text = "add phone"
                cell.delegate = self
                
                return cell
            }
            if indexPath.row == 0 && indexPath.section == 2 && secondSectionCounter == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.CellIdentifiers.numberEmailId) as! NumberEmailTableViewCell
                
                cell.informationLabel?.text = "add email"
                cell.delegate = self
                
                return cell
            }
            if indexPath.row == 0 && indexPath.section == 1 && firstSectionCounter != 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.CellIdentifiers.deleteCellId) as! TelephoneTableViewCell
                
                cell.numberPhoneTextField?.placeholder = "Your telephone"
                cell.delegate = self
                cell.numberPhoneTextField.delegate = self
                
                return cell
            }
            if indexPath.row == 0 && indexPath.section == 2 && secondSectionCounter != 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.CellIdentifiers.deleteCellId) as! TelephoneTableViewCell
                
                cell.numberPhoneTextField?.placeholder = "Your email"
                cell.delegate = self
                cell.numberPhoneTextField.delegate = self
                
                return cell
            }
           
            return UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 40
        }

        // MARK: - Send data in ContactViewController
        override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
               if segue.identifier == "saveId",
                let name = (addInformationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TestTableViewCell).textField?.text,
                let sername = (addInformationTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TestTableViewCell).textField?.text
               {
                    let company = (addInformationTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! TestTableViewCell).textField?.text ?? ""
                    var telephones: [String] = [""]
                    var emails: [String] = [""]
                    let id = human?.id
                    
                    if firstSectionCounter != 1 {
                        telephones = arrayData(tableView: addInformationTableView, section: 1) as! [String]
                    }
                    
                    if secondSectionCounter != 1 {
                        emails = arrayData(tableView: addInformationTableView, section: 2) as! [String]
                    }
                    
                human = Contact(name: name, sername: sername, company: company, telephoneNumber: telephones, email: emails, photo: contactImage.image, id: id)
               }
        }
    }

    // MARK: - Delete and add new field
    extension AddContactViewController
    {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            if indexPath.section == 1 {
                firstSectionCounter += 1
                tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            }
            if indexPath.section == 2 {
                secondSectionCounter += 1
                tableView.insertRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
            }
        }
    }

    extension AddContactViewController: NumberEmailTableViewCellDelegate
    {
        func onClickCell(_ cell: NumberEmailTableViewCell) {
            if let index = addInformationTableView.indexPath(for: cell) {
                if index.section == 1 {
                    firstSectionCounter += 1
                    addInformationTableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
                }
                if index.section == 2 {
                    secondSectionCounter += 1
                    addInformationTableView.insertRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
                }
            }
        }
    }

    extension AddContactViewController: TelephoneTableViewCellDelegate
    {
        func onClickCell(_ cell: TelephoneTableViewCell) {
            if let index = addInformationTableView.indexPath(for: cell) {
                if index.section == 1 {
                    firstSectionCounter -= 1
                    addInformationTableView.deleteRows(at: [index], with: .automatic)
                }
                if index.section == 2 {
                    secondSectionCounter -= 1
                    addInformationTableView.deleteRows(at: [index], with: .automatic)
                }
            }
        }
        
        
    }

    extension AddContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
    {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                contactImage.image = pickedImage
            }
            dismiss(animated: true, completion: nil)
        }
    }

    extension AddContactViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            let nameTextField = (addInformationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TestTableViewCell).textField
            let sernameTextField = (addInformationTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TestTableViewCell).textField
            
            if nameTextField?.text?.isEmpty == false && sernameTextField?.text?.isEmpty == false {
                savedButton.isEnabled = true
            } else { savedButton.isEnabled = false }
        }
   
    }

extension AddContactViewController {
    func arrayData(tableView: UITableView, section: Int) -> [String?]
    {
        let end = tableView.numberOfRows(inSection: section)
        var array: [String?] = []
        for index in 0 ..< end - 1 {
            let item = (tableView.cellForRow(at: IndexPath(row: index, section: section)) as! TelephoneTableViewCell).numberPhoneTextField.text
            array.append(item)
        }
        return array
    }
}

    // MARK: - UIConstants
    private enum UIConstants {
        enum CellIdentifiers {
            static let myCellId = "myCellId"
            static let numberEmailId = "numberEmailId"
            static let deleteCellId = "deleteEmailNumberId"
        }
    }


