//
//  ViewController.swift
//  Project7
//
//  Created by Vitaliy on 13.01.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions: [Petition] = []
    
    var filteredPetitions: [Petition] = []
    
    var currentFilterQuery: String? = nil
    
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = getDefaultTitle()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsTapped))
        
        
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        
        navigationItem.leftBarButtonItems = [filterButton]
        
        requestInitialData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCurrentPititionsList().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentPetitions = getCurrentPititionsList()
        
        cell.textLabel?.text = currentPetitions[indexPath.row].title
        cell.detailTextLabel?.text = currentPetitions[indexPath.row].body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let currentPetitions = getCurrentPititionsList()
        vc.detailItem = currentPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func creditsTapped() {
        let ac = UIAlertController(title: "Credits", message: "All data is provided by \"We The People API of the Whitehouse\"", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc private func filterTapped() {
        let ac = UIAlertController(title: "Enter filter query", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        if let currentFilterQuery = currentFilterQuery {
            ac.textFields?[0].text = currentFilterQuery
        }
       
        
        let submitAction  = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            
            guard let filterQuery = ac?.textFields?[0].text else { return }
            
            self?.submit(filterQuery)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc private func clearFilterTapped() {
        currentFilterQuery = nil
        filteredPetitions.removeAll()
        tableView.reloadData()
        title = getDefaultTitle()
        navigationItem.leftBarButtonItems?.remove(at: 1)
    }
    
    private func submit(_ query: String) {
        if query.isEmpty {
            return
        }
        
        currentFilterQuery = query
        filteredPetitions.removeAll()
        
        filteredPetitions = petitions.filter{ petition in
            if petition.title.localizedCaseInsensitiveContains(query) {
                return true
            } else {
                return false
            }
        }
        
        tableView.reloadData()
        title = query
        
        if navigationItem.leftBarButtonItems?.count ?? 0 < 2 {
            let clearFilterButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(clearFilterTapped))
            navigationItem.leftBarButtonItems?.insert(clearFilterButton, at: 1)
        }

    }
    
    private func getCurrentPititionsList() -> [Petition] {
        if currentFilterQuery == nil {
            return petitions
        } else {
            return filteredPetitions
        }
    }
    
    private func requestInitialData() {
        if(dataTask?.state == .running) {
            return
        }
        
        let urlString: String
        
        
        switch getCurrentPetitionsScreen() {
        case .recent:
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        case .topRated:
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            
            // 4
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                // 5
                if let error = error {
                    print("error")
                    print("DataTask error: \(error.localizedDescription)\n")
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    
                    
                    if let petitions = self?.parseData(data){
                        DispatchQueue.main.async {
                            self?.updateUI(petitions: petitions)
                        }
                    }
                }
            }
            // 7
            dataTask?.resume()
        } else {
            showError()
        }
    }
    
    private func updateUI(petitions: [Petition]) {
        self.petitions = petitions
        tableView.reloadData()
    }
    
    private func parseData(_ data: Data) -> [Petition] {
        do {
            let decoder = JSONDecoder()
            let jsonPetitions = try decoder.decode(Petitions.self, from: data)
            return jsonPetitions.results
        } catch {
            print("parse error:\(error)")
            showError()
            return []
        }
    }
    
    private func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func getCurrentPetitionsScreen() -> PetitionsScreen {
        if navigationController?.tabBarItem.tag == 0 {
            return PetitionsScreen.recent
        } else {
            return PetitionsScreen.topRated
        }
    }
    
    private func getDefaultTitle() -> String {
        switch getCurrentPetitionsScreen() {
        case .recent:
            return "Most Recent"
        case .topRated:
            return "Top Rated"
        }
    }
}

enum PetitionsScreen{
    case recent
    case topRated
}

