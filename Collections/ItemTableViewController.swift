//
//  ItemTableViewController.swift
//  Collections
//
//  Created by Megan Weijiang on 2/23/17.
//  Copyright © 2017 Megan Weijiang. All rights reserved.
//

import UIKit
import os.log

class ItemTableViewController: UITableViewController {

    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleItems()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let item = items[indexPath.row]
        
        cell.itemNameLabel.text = item.name
        cell.photoImageView.image = item.photo
        cell.favoriteControl.favorite = item.favorite
        
    
        let dateFormatter = DateFormatter()
        let currentDate = NSDate()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let convertedDate = dateFormatter.string(from: currentDate as Date)
        cell.dateLabel.text = convertedDate
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new item.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let itemDetailViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedItemCell = sender as? ItemTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedItem = items[indexPath.row]
            itemDetailViewController.item = selectedItem
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }

    
    private func loadSampleItems() {
        let photo = UIImage(named: "defaultImage")
        guard let item1 = Item(name: "Pile of Cats", photo: photo, description: "You found a pile of cats!", favorite: true) else {
            fatalError("Unable to instantiate item1")
        }
        items += [item1]
    }
    
    // Actions
    
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ViewController, let item = sourceViewController.item {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing item.
                items[selectedIndexPath.row] = item
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new item.
                let newIndexPath = IndexPath(row: items.count, section: 0)
                
                items.append(item)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}
