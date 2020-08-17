//
//  ViewController.swift
//  iOS_ToDo
//
//  Created by Genaro Arvizu on 10/08/20.
//  Copyright © 2020 Genaro Arvizu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrString: [NSManagedObject] = []
    
    var taskSelected: NSManagedObject?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let task: NSManagedObject = taskSelected, let identifier: String = segue.identifier else {
            return
        }
        
        if identifier == "seeDetail" {
            let destination: DetailViewController = segue.destination as! DetailViewController
            destination.task = task
        }
        
    }
    
    func insert(name: String) {
        //        arrString.append(name)
        
        guard let appDelagate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelagate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task",
                                                in: managedContext)!
        
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(name, forKey: "name")
        task.setValue(UUID(), forKey: "id")
        
        do {
            try managedContext.save()
            arrString.append(task)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func fetch() {
        
        guard let appDelagate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelagate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do {
            arrString = try managedContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func delete(id: UUID) {
        guard let appDelagate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelagate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        do {
            let task = try managedContext.fetch(fetchRequest)
            
            guard let firstTask = task.first else {
                return
            }
                
            managedContext.delete(firstTask)
            try managedContext.save()
            
            arrString.removeAll(where: {$0 == firstTask})
                        
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    
    @IBAction func userTappedAdd(_ sender: Any) {
        print(#function)
        
        let alert: UIAlertController = UIAlertController(title: "Add Information",
                                                         message: "Please add a task name",
                                                         preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel",
                                                        style: .destructive,
                                                        handler: nil)
        
        let addAction: UIAlertAction = UIAlertAction(title: "Add",
                                                     style: .default) { (action: UIAlertAction) in
                                                        
                                                        guard let textField: UITextField = alert.textFields?.first,
                                                            let name: String = textField.text, !name.isEmpty else {
                                                                return
                                                        }
                                                        self.insert(name: name)
                                                        self.tableView.reloadData()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        alert.addTextField(configurationHandler: nil)
        
        present(alert,
                animated: true,
                completion: nil)
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrString.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Basic", for: indexPath)
        //cell.textLabel?.text = arrString[indexPath.row]
        let task = arrString[indexPath.row]
        cell.textLabel?.text = task.value(forKey: "name") as? String
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            arrString.remove(at: indexPath.row)
            let task = arrString[indexPath.row]
            delete(id: task.value(forKey: "id") as! UUID)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskSelected = arrString[indexPath.row]
        performSegue(withIdentifier: "seeDetail", sender: nil)
    }
    
}

