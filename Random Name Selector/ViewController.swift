//
//  ViewController.swift
//  Random Name Selector
//
//  Created by Scott Lougheed on 2020/2/22.
//  Copyright © 2020 Scott Lougheed. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	var names = [String]()
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Book Club Members"
		
		if let savedNames = defaults.stringArray(forKey: "names") {
			names = savedNames
		}
		
		createDefaultBarButtonItems()
	}
	
	func createDefaultBarButtonItems() {
		navigationItem.rightBarButtonItems = []
		navigationItem.leftBarButtonItems = []
		let addNewName = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addName))
		let displayRandomButton = UIBarButtonItem(title: "Choose!", style: .plain, target: self, action: #selector(displayRandom))
		let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTable))
		navigationItem.rightBarButtonItems = [displayRandomButton]
		navigationItem.leftBarButtonItems = [addNewName, edit]
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return names.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Member", for: indexPath)
		cell.textLabel?.text = names[indexPath.row]
		
		return cell
	}
	
	@objc func addName() {
		let ac = UIAlertController(title: "Add New Member", message: nil, preferredStyle: .alert)
		ac.addTextField(configurationHandler: { textField in
			textField.autocapitalizationType = .words
			textField.placeholder = "Member's first name"
		})
		
		let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] (action: UIAlertAction) in
			guard let answer = ac?.textFields?[0].text else { return }
			self?.names.append(answer)
			self?.defaults.set(self?.names, forKey: "names")
			self?.tableView.reloadData()
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		ac.addAction(submitAction)
		ac.addAction(cancelAction)
		
		present(ac, animated: true)
	}
	
	@objc func displayRandom() {
		
		if names.count == 0 {
			let alert = UIAlertController(title: "Oops!", message: "Please add some book club members first!", preferredStyle: .alert)
			let dismissAction = UIAlertAction(title: "Got it", style: .cancel)
			
			alert.addAction(dismissAction)
			
			present(alert, animated: true)
		} else {
			let nextBookPicker = names.randomElement()
			let alert = UIAlertController(title: "Next Boook Chooser", message: nextBookPicker, preferredStyle: .alert)
			let dismissAction = UIAlertAction(title: "Great!", style: .cancel)
			
			alert.addAction(dismissAction)
			present(alert, animated: true)
		}
		
	}
	
	@objc func editTable() {
		tableView.isEditing = true
		navigationItem.rightBarButtonItems = []
		navigationItem.leftBarButtonItems = []
		let finishEditing = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
		navigationItem.rightBarButtonItems = [finishEditing]
	}
	
	@objc func doneEditing() {
		tableView.isEditing = false
		createDefaultBarButtonItems()
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			names.remove(at: indexPath.row)
			defaults.set(names, forKey: "names")
		}
		tableView.deleteRows(at: [indexPath], with: .none)
	}
}
