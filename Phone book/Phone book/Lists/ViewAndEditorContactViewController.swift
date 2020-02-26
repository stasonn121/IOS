//
//  ViewAndEditorContactViewController.swift
//  Phone book
//
//  Created by user on 18.02.2020.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class ViewAndEditorContactViewController: UIViewController {
    
    //MARK: - Public variable
    @IBOutlet weak var viewAndEditTableView: UITableView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    var contact: Contact = Contact()
    var image: UIImage?
    //MARK: - Private variable
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        // Do any additional setup after loading the view.
    }
    private func initialization() {
        contactImage.image = image
        contactImage.layer.cornerRadius = contactImage.bounds.width / 2
        
        let name = contact.name
        let sername = contact.sername
        contactName.text = name + " " + sername
        
    }
    
}
//MARK: - Delegate, DataSource
extension ViewAndEditorContactViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 3 }
        else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.CellIdentifiers.standartCellId)
        
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            cell?.textLabel?.text = "Telephone"
            cell?.detailTextLabel?.text = recordArray(array: contact.telephoneNumber)
            cell?.detailTextLabel?.numberOfLines = contact.telephoneNumber.count
        case IndexPath(row: 1, section: 0):
            cell?.textLabel?.text = "Email"
            cell?.detailTextLabel?.text = recordArray(array: contact.email)
            cell?.detailTextLabel?.numberOfLines = contact.email.count
        case IndexPath(row: 2, section: 0):
            cell?.textLabel?.text = "Work"
            cell?.detailTextLabel?.text = contact.company
        case IndexPath(row: 0, section: 1):
            cell?.textLabel?.text = "Delete"
            cell?.textLabel?.textColor = .red
            cell?.detailTextLabel?.text = nil
        default:
            break
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == IndexPath(row: 0, section: 1) {
            performSegue(withIdentifier: "deleteContact", sender: self)
        }
    }
}

extension ViewAndEditorContactViewController {
    func recordArray(array: [String]) -> String
    {
        var outputString: String = ""
        for index in 0 ..< array.count {
            outputString += array[index] + (index == array.count - 1 ? "" : "\n")
        }
        return outputString
    }
}

extension ViewAndEditorContactViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "editContact",
            let editController = (segue.destination as? UINavigationController)?.viewControllers.first as? AddContactViewController else { return }
        
            segue.destination.modalPresentationStyle = .fullScreen
            editController.createContact = false
            editController.human = contact
    }
}

private enum UIConstants {
       enum CellIdentifiers {
            static let myCellId = "myCellId"
            static let numberEmailId = "numberEmailId"
            static let deleteCellId = "deleteEmailNumberId"
            static let standartCellId = "standartId"
    }
}

