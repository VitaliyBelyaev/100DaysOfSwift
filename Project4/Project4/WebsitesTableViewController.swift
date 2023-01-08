//
//  WebsitesTableViewController.swift
//  Project4
//
//  Created by Vitaliy on 08.01.2023.
//

import UIKit

class WebsitesTableViewController: UITableViewController {

    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Websites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)

        cell.textLabel?.text = websites[indexPath.row]

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewViewController
        
        if let viewController = vc {
            viewController.websiteToLoad = websites[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
