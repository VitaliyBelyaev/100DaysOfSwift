//
//  ViewController.swift
//  ShoppingList
//
//  Created by Vitaliy on 12.01.2023.
//

import UIKit

class ViewController: UITableViewController {

    var shopList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTapped))
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTapped)),
            
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(onShareTapped))
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopItem", for: indexPath)
        
        cell.textLabel?.text = shopList[indexPath.row]
        
        return cell
    }

    @objc private func clearList() {
        shopList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc private func onAddTapped() {
        let ac = UIAlertController(title: "Enter item", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        let submitAction  = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            
            guard let item = ac?.textFields?[0].text else { return }
            
            self?.submitItem(item)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc private func onShareTapped() {
        
        let shopListString = shopList.joined(separator: "\n")
        
        let ac = UIActivityViewController(activityItems: [shopListString], applicationActivities: nil)
        
        present(ac, animated: true)
    }

    
    private func submitItem(_ item: String){
        shopList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

