//
//  SideMenuViewController.swift
//  MapTask
//
//  Created by Salah  on 4/13/21.
//

import UIKit

class SideMenuViewController: UITableViewController {

    
    var sideMenuItems = ["Home","Location","Destination","Wallet","Policy","Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.sideMenuCellIdentifier)
        tableView.backgroundColor = ColorsUtility.colorWithHexString("#B8B8B8")
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sideMenuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.sideMenuCellIdentifier, for: indexPath)
        cell.textLabel?.text = sideMenuItems[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.backgroundColor = ColorsUtility.colorWithHexString("#B8B8B8")
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

   

}
