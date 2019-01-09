//
//  ViewController.swift
//  Learn-CoreData
//
//  Created by Tiara Mahardika on 09/01/19.
//  Copyright © 2019 Tiara Mahardika. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var names: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "the list"
        tableView.register(UITableView.self, forCellReuseIdentifier: "cell")
    }
    
    
    @IBAction func addName(_ sender: Any) {
        let alert =  UIAlertController(title: "new name",
                                       message: "add new names",
                                       preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else{
                    return
            }
            
            self.names.append(nameToSave)
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
    
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,animated: true)
    }
    

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    
}

