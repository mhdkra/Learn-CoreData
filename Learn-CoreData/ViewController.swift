//
//  ViewController.swift
//  Learn-CoreData
//
//  Created by Tiara Mahardika on 09/01/19.
//  Copyright © 2019 Tiara Mahardika. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var people: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "the list"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    
    
    @IBAction func addName(_ sender: Any) {
        let alert =  UIAlertController(title: "new name",
                                       message: "add new names",
                                       preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
    
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,animated: true)
    }
    

    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        //Sebelum dapat menyimpan atau mengambil dari Data Core,terlebih dahulu mengambil NSManagedObjectContext.
        //you can consider managed object context sebagai "scratchpad" dalam memori untuk bekerja dengan managed object.
        
        //Think of saving a new managed object to Core Data as a two-step process:
        //first, you insert a new managed object into a managed object context;
        //once you’re happy, you “commit” the changes in your managed object context to save it to disk.
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        //Anda mungkin bertanya-tanya tentang apa itu NSEntityDescription.
        //Ingat sebelumnya, NSManagedObject disebut kelas bentuk-shifter karena dapat mewakili entitas apa pun.
        //Deskripsi entitas adalah bagian yang menghubungkan definisi entitas dari Model Data Anda dengan instance NSManagedObject saat runtime.
        let entity =
            NSEntityDescription.entity(forEntityName: "Person",
                                       in: managedContext)!
        

        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    

}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let person = people[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            cell.textLabel?.text =
                person.value(forKeyPath: "name") as? String
            return cell
    }


}

