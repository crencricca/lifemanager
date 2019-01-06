//
//  MainScreenViewController.swift
//  Life Manager
//
//  Created by Catie Rencricca on 12/20/18.
//  Copyright © 2018 Catie Rencricca. All rights reserved.
//

import UIKit
import CoreData

class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var listNameLabel: UITextField!
    var tasksTableView: UITableView!
    var addTask: UITextField!
    var addTaskButton: UIButton!
    var refresher = UIRefreshControl()
    
    let labelFont = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 30)
    let textFont = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 20)
    let pagePadding = 15
    let cellHeight: CGFloat = 35
    
    var taskData: [NSManagedObject] = []
    var listData: [NSManagedObject] = []
    
    var contentHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        createTable()
        setupConstraints()
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
            NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        //3
        do {
            taskData = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        reload()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            listNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (15+contentHeight)),
            listNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            addTask.heightAnchor.constraint(equalToConstant: 20),
            addTask.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8),
            addTask.topAnchor.constraint(equalTo: listNameLabel.bottomAnchor, constant: 5),
            addTask.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            addTaskButton.leadingAnchor.constraint(equalTo: addTask.trailingAnchor, constant: 15),
            addTaskButton.topAnchor.constraint(equalTo: addTask.topAnchor, constant: -15),
            ])
    }
    
    // THIS DOES NOT RUN PROPERLY
    func updateConstraints() {
        print("hello!")
        NSLayoutConstraint.activate([
            addTask.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(contentHeight + 70)),
            ])
    }
    
    func createTable() {
        let tableHeight = cellHeight * CGFloat(taskData.count)
        
        listNameLabel = UITextField()
        listNameLabel.translatesAutoresizingMaskIntoConstraints = false
        listNameLabel.text = "Default List"
        listNameLabel.textColor = .black
        listNameLabel.font = labelFont
        view.addSubview(listNameLabel)
        
        let screenSize = UIScreen.main.bounds
        let tableSize: CGRect = CGRect(x: 30, y: screenSize.height * 0.21, width: screenSize.width * 0.8, height: tableHeight)
        tasksTableView = UITableView(frame: tableSize, style: UITableView.Style.plain)
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        tasksTableView.isScrollEnabled = false
        self.tasksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "task")
        self.tasksTableView.delegate = self
        self.tasksTableView.dataSource = self
        view.addSubview(tasksTableView)
        
        addTask = UITextField()
        addTask.translatesAutoresizingMaskIntoConstraints = false
        addTask.font = textFont
        addTask.backgroundColor = .gray
        addTask.delegate = self
        view.addSubview(addTask)
        
        addTaskButton = UIButton()
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.addTarget(self, action: #selector(enterPressed), for: .touchUpInside)
        addTaskButton.setTitle("+", for: .normal)
        addTaskButton.backgroundColor = .blue
        view.addSubview(addTaskButton)
    }
    
    func save(name: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Task",
                                       in: managedContext)!
        
        let task = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        // 3
        task.setValue(name, forKeyPath: "name")

        // 4
        do {
            try managedContext.save()
            taskData.append(task)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @objc func enterPressed(_ textField: UITextField) {
        if addTask.text != "" {
            self.save(name: addTask.text!) // add guard let to make sure this is never nil!
            addTask.text = ""
            reload()
            addTask.resignFirstResponder()
            contentHeight += cellHeight
        }
    }
    
    func reload() {
        contentHeight = cellHeight * CGFloat(taskData.count) + listNameLabel.bounds.size.height
        print(contentHeight)
        let screenSize = UIScreen.main.bounds
        tasksTableView.frame = CGRect(x: 30, y: screenSize.height * 0.21, width: screenSize.width * 0.8, height: contentHeight)
        tasksTableView.reloadData()
        self.refresher.endRefreshing()
//        addTask.setNeedsUpdateConstraints()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath as IndexPath)
        let task = taskData[indexPath.row]
        cell.setNeedsUpdateConstraints()
        cell.textLabel?.text = task.value(forKeyPath: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
//            // Create Fetch Request
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task", for: indexPath.row)
//
//            // Create Batch Delete Request
//            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//            do {
//                try managedObjectContext.execute(batchDeleteRequest)
//
//            } catch {
//                // Error Handling
//            }
            let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            
            managedObjectContext.delete(taskData[indexPath.row] as NSManagedObject)
            taskData.remove(at: indexPath.row)
            
            let _ : NSError! = nil
            do {
                try managedObjectContext.save()
                tasksTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                reload()
                print("deleting")
                print(taskData)
            } catch {
                print("error : \(error)")
            }
        }
    }

}
