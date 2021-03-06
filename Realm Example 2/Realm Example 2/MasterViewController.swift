//
//  MasterViewController.swift
//  Realm Example 2
//
//  Created by Lucien Dupont on 4/24/17.
//  Copyright © 2017 Lucien Dupont. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {

	var detailViewController: DetailViewController? = nil
	var objects:Results<DateModel>? = nil
	var token:NotificationToken? = nil


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		navigationItem.leftBarButtonItem = editButtonItem

		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
		navigationItem.rightBarButtonItem = addButton
		if let split = splitViewController {
		    let controllers = split.viewControllers
		    detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		let realm = try! Realm()
		
		objects = realm.objects(DateModel.self)
		
		token = realm.addNotificationBlock { notification, realm in
			
			// print("got realm change notification")
			
			self.tableView.reloadData()
		}
		
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func insertNewObject(_ sender: Any) {
		// objects.insert(NSDate(), at: 0)
		// let indexPath = IndexPath(row: 0, section: 0)
		
		let newDateObject = DateModel()
		
		let realm = try! Realm()
		
		try! realm.write {
			realm.add(newDateObject)
		}
		
		// tableView.insertRows(at: [indexPath], with: .automatic)
	}

	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
//		    if let indexPath = tableView.indexPathForSelectedRow {
//		        let object = objects[indexPath.row] as! NSDate
//		        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//		        controller.detailItem = object
//		        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//		        controller.navigationItem.leftItemsSupplementBackButton = true
//		    }
		}
	}

	// MARK: - Table View

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects!.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		let object = objects![indexPath.row]
		cell.textLabel!.text = object.date.description
		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			
			let realm = try! Realm()
			
			// get the object that we are wanting to delete
			let objectToDelete = objects?[indexPath.row]
			
			try! realm.write {
				realm.delete(objectToDelete!)
			}
			
			// objects.remove(at: indexPath.row)
		    // tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
		    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}


}

