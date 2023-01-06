//
//  FlagDetailedViewController.swift
//  FlagViewer
//
//  Created by Vitaliy on 06.01.2023.
//

import UIKit

class FlagDetailedViewController: UIViewController {

    @IBOutlet var flagImageView: UIImageView!
    
    var flagData: FlagData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        if let flagData = flagData {
            title = flagData.countryName
            flagImageView.image = UIImage(named:flagData.imageName)
            flagImageView.layer.borderWidth = 0.5
            flagImageView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @objc private func shareTapped() {
        guard let image = flagImageView.image?.jpegData(compressionQuality: 1.0) else {
            print("No image found")
            return
        }
        
        var shareItems: [Any] = [image]
        if let flagData = flagData {
            shareItems.append(flagData.countryName)
        }
        let vc = UIActivityViewController(activityItems: shareItems, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
