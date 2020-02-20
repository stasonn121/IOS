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
    var contact: Contact? = Contact()
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
        contactImage.layer.cornerRadius = 50
        if let name = contact?.name, let sername = contact?.sername {
            contactName.text = name + " " + sername
        }
    }
    
}
//MARK: - Delegate, DataSource
extension ViewAndEditorContactViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.CellIdentifiers.standartCellId)
        
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "Telephone"
            cell?.detailTextLabel?.text = contact?.telephoneNumber
        case 1:
            cell?.textLabel?.text = "Email"
            cell?.detailTextLabel?.text = contact?.email
        case 2:
            cell?.textLabel?.text = "Work"
           cell?.detailTextLabel?.text = contact?.company
        default:
            break
        }
        
        return cell!
    }
    
}

extension ViewAndEditorContactViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "editContact",
           let editController = segue.destination as? AddContactViewController else { return }
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

