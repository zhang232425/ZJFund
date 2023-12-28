//
//  MenuSectionVC.swift
//  ZJFund
//
//  Created by Jercan on 2023/12/25.
//

import UIKit

class MenuSectionVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCell(UITableViewCell.self)
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
        cell.textLabel?.text = "菜单\(indexPath.row + 1)"
        return cell
    }

}
