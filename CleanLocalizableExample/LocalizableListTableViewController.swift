//
//  LocalizableListTableViewController.swift
//  CleanLocalizableExample
//
//  Created by Gino Wu on 2/25/18.
//  Copyright © 2018 Gino Wu. All rights reserved.
//

import UIKit

class LocalizableListTableViewController: UITableViewController {

    let fruits: [String] = [
        NSLocalizedString("LocalizableListTableViewController:Fruit:Apple", comment: "Apple title"),
        NSLocalizedString("LocalizableListTableViewController:Fruit:Orange", comment: "Orange title"),
        NSLocalizedString("LocalizableListTableViewController:Fruit:Grape", comment: "Grape title"),
        NSLocalizedString("LocalizableListTableViewController:Fruit:Strawberry", comment: "Strawberry title")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { fatalError() }
        cell.textLabel?.text = fruits[indexPath.row]
        return cell
    }

}
