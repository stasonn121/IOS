//
//  ContactListTableViewController.swift
//  Phone book
//
//  Created by user on 12.02.2020.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    var humans: [Contact] = []
    var findHumans: [Contact] = []
    var isEmptySearchBar = true
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if isEmptySearchBar { return humans.last?.section ?? 0}
        else { return findHumans.last?.section ?? 0 }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isEmptySearchBar { return counterCellsInThisSection(array: humans, numberSection: section + 1)}
        else { return counterCellsInThisSection(array: findHumans, numberSection: section + 1) }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = tableView.dequeueReusableCell(withIdentifier: "Contact", for: indexPath) as! StyleTableViewCell
        
        
        if isEmptySearchBar && indexPath.section == humans[findSection(array: humans, section: indexPath.section + 1) + indexPath.row].section - 1  {
            contact.secondNameUser?.text = humans[findSection(array: humans, section: indexPath.section + 1) + indexPath.row].name
            contact.firstNameUser?.text = humans[findSection(array: humans, section: indexPath.section + 1) + indexPath.row].sername
        }
        else if !isEmptySearchBar && indexPath.section == findHumans[findSection(array: findHumans, section: indexPath.section + 1) + indexPath.row].section - 1  {
            contact.secondNameUser?.text = findHumans[findSection(array: findHumans, section: indexPath.section + 1) + indexPath.row].name
            contact.firstNameUser?.text = findHumans[findSection(array: findHumans, section: indexPath.section + 1) + indexPath.row].sername
        }
        
        return contact
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.height, height: 20))
        view.backgroundColor = UIColor.lightGray
        
        let label = UILabel(frame: CGRect(x: 10, y: 6, width: 14, height: 14))
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        let letterSection = findSection(array: humans, section: section + 1)
        if let char = humans[letterSection].sername.first {
            label.text = String(char)
        }
               
        view.addSubview(label)
        return view
    }
 
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
}

extension ContactListTableViewController {
    @IBAction func cancelToContactsViewController(_ seque: UIStoryboardSegue){ }
    @IBAction func savePlayerDetail(_ segue: UIStoryboardSegue) {
        guard
        segue.identifier == "saveId",
            let addOrEditContactViewController = segue.source as? AddContactViewController,
            let contact = addOrEditContactViewController.human
            else { return }
        
        if addOrEditContactViewController.createContact == true {
            humans.append(contact)
            humans = humans.sorted(by: {$0.sername < $1.sername})
            humans = numerationContact(array: humans)
        }
        if addOrEditContactViewController.createContact == false, let idEditContact = contact.id {
            humans[idEditContact] = contact
            humans = humans.sorted(by: {$0.sername < $1.sername})
            humans = numerationContact(array: humans)
        }
    tableView.reloadData()
    }
}

extension ContactListTableViewController {
    
    //MARK: Находит номер первого элемента в секции
    func findSection ( array: [Contact], section: Int ) -> Int {
        var positionSection = 0
        for index in 0 ..< array.count {
            if array[index].section == section {
                positionSection = index
                break
            }
        }
        return positionSection
    }
    
    //MARK: Разбивает контакты на секции и нумерует секцию и ячейчку
    func numerationContact (array: [Contact]) -> [Contact]
    {
        var section = 1
        var cellInSection = 1
        var index = 0
        var arrayCopy = array
        if (array.count == 1)
        {
            arrayCopy[0].section = 1
            arrayCopy[0].cellInSection = 1
            arrayCopy[0].id = 0
        }
        while (index < array.count - 1)
        {
            if array[index].sername.first == array[index + 1].sername.first {
                arrayCopy[index].section = section
                arrayCopy[index].cellInSection = cellInSection
                arrayCopy[index].id = index
            } else {
                arrayCopy[index].section = section
                arrayCopy[index].cellInSection = cellInSection
                arrayCopy[index].id = index
                section += 1
                cellInSection = 0
            }
            index += 1
            cellInSection += 1
            
        }
        if index == array.count - 1 {
            arrayCopy[index].section = section
            arrayCopy[index].cellInSection = cellInSection
            arrayCopy[index].id = index
        }
        
        return arrayCopy
    }
    
    //MARK: Считает кол-во ячеек в секции
    func counterCellsInThisSection (array: [Contact], numberSection: Int) -> Int
    {
        var pointerCells = findSection(array: array, section: numberSection)
        var change = false
        var counterCells = 1
        
        while change == false && pointerCells < array.count - 1 {
            if array[pointerCells].section != array[pointerCells + 1].section {
                change = true
                break
            }
            counterCells += 1
            pointerCells += 1
        }
        
        return counterCells
    }
    //MARK: Находит контакт по положению в табл
    func findContactByIndex(indexPath: IndexPath) -> Contact? {
        var contact: Contact?
        for index in humans {
            if index.section - 1 == indexPath.section && index.cellInSection - 1 == indexPath.row {
                contact = index
                break
            }
        }
        return contact
    }
    
}

extension ContactListTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewThisContact",
           let editorController = segue.destination as? ViewAndEditorContactViewController,
           let locationCell = tableView.indexPathForSelectedRow {
            
            editorController.contact = findContactByIndex(indexPath: locationCell)
            editorController.image = editorController.contact?.photo ?? #imageLiteral(resourceName: "userContact")
        }
        
        if segue.identifier == "createContact",
            let createController = (segue.destination as? UINavigationController)?.viewControllers.first as? AddContactViewController {
            createController.createContact = true
        }
    }
}

extension ContactListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isEmptySearchBar = true
        } else {
            let search = searchText.lowercased()
            findHumans = humans.filter { $0.sername == search || $0.name == search }
            findHumans = numerationContact(array: findHumans)
            isEmptySearchBar = false
        }
        tableView.reloadData()
    }
}
