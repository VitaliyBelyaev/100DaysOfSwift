//
//  ViewController.swift
//  FlagViewer
//
//  Created by Vitaliy on 05.01.2023.
//

import UIKit

class ViewController: UITableViewController {

   
    
    private var flags: [FlagData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FlagViewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.rowHeight = 50.0
        
        flags = getFlags(imageNames: getFlagImageNames().shuffled())
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlagItem", for: indexPath)
        
        let flagImageView = UIImageView()
        let countryNameLabel = UILabel()
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        countryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(flagImageView)
        cell.contentView.addSubview(countryNameLabel)
    
        cell.contentView.addConstraints(
            [
                
                NSLayoutConstraint(item: flagImageView, attribute: .leading, relatedBy: .equal, toItem: flagImageView.superview, attribute: .leading, multiplier: 1.0, constant: 20.0),
                
                NSLayoutConstraint(item: flagImageView, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0),
                
                NSLayoutConstraint(item: flagImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0),
                
                NSLayoutConstraint(item: flagImageView, attribute: .width, relatedBy: .equal, toItem: flagImageView, attribute: .height, multiplier: 2.0, constant: 0.0),
                
                NSLayoutConstraint(item: countryNameLabel, attribute: .leading, relatedBy: .equal, toItem: flagImageView, attribute: .trailing, multiplier: 1.0, constant: 16.0),
                
                NSLayoutConstraint(item: countryNameLabel, attribute: .centerY, relatedBy: .equal, toItem: cell.contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0),
                
                NSLayoutConstraint(item: countryNameLabel, attribute: .trailing, relatedBy: .equal, toItem: countryNameLabel.superview, attribute: .trailing, multiplier: 1.0, constant: 16.0)
                
            ]
        )
        
        let flagData = flags[indexPath.row]
        flagImageView.image = UIImage(named: flagData.imageName)
        flagImageView.layer.borderWidth = 0.5
        flagImageView.layer.borderColor = UIColor.gray.cgColor
        countryNameLabel.text = flagData.countryName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let flagDetailedVc = storyboard?.instantiateViewController(withIdentifier: "FlagDetailed") as? FlagDetailedViewController
        
        if let viewController = flagDetailedVc {
            viewController.flagData = flags[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func getFlagImageNames() -> [String] {
        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fileManager.contentsOfDirectory(atPath: path)
        
        var imageNames = [String]()
        for item in items {
            if item.hasPrefix("flag") {
                imageNames.append(item)
            }
        }
        return imageNames
    }
    
    private func getPrettyCountryNameFromImageName(_ imageName: String) -> String {
        
        let undercsoreChar: Character = "_"
        let dotChar: Character = "."
        let splitted = imageName.split { char in
            char == undercsoreChar || char == dotChar
        }
        
        if splitted.count == 3 {
            return getPrettyCountryTitle(String(splitted[1]))
        } else {
            return imageName
        }
    }
    
    private func getPrettyCountryTitle(_ originCountryTitle: String) -> String {
        if (originCountryTitle == "us" || originCountryTitle == "uk") {
            return originCountryTitle.uppercased()
        } else {
            return originCountryTitle.capitalized
        }
    }
    
    private func getFlags(imageNames: [String]) -> [FlagData] {
        imageNames.map { imageName in
            FlagData(imageName: imageName,
                     countryName: getPrettyCountryNameFromImageName(imageName)
            )
        }
    }
}

struct FlagData {
    var imageName:String
    var countryName:String
}

