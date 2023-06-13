//
//  CreatureTable.swift
//  Life-FormSearch
//
//  Created by Juliana Nielson on 6/9/23.
//

import UIKit

extension CreatureTable: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        fetchMatchingCreatures()
        searchBar.resignFirstResponder()
    }
}

@MainActor
class CreatureTable: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var creatures = [CreatureData]()
    var tasks: [IndexPath: Task<Void, Never>] = [:]
    
    let creatureDataController = CreatureDataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func fetchMatchingCreatures() {
        
        self.creatures = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        
        if !searchTerm.isEmpty {
            
            let query: [String: String] = [
                "q" : searchTerm
            ]
            
            Task {
                do {
                    let creaturesData = try await creatureDataController.fetchCreatures(matching: query)
                    self.creatures = creaturesData
                    self.tableView.reloadData()
                } catch {
                    print("Unable to fetch creatures. \(error)")
                }
            }
        }
    }

    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let creature = creatures[indexPath.row]
        
        cell.textLabel?.text = creature.scientificName
        cell.detailTextLabel?.text = creature.commonNames
    }
    
    //Overriden Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creatures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creatureCell", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
