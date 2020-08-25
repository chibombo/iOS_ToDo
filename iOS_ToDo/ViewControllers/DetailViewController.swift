//
//  DetailViewController.swift
//  iOS_ToDo
//
//  Created by Genaro Arvizu on 12/08/20.
//  Copyright © 2020 Genaro Arvizu. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfDetail: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    var task: NSManagedObject!
    var timer: Timer?
    
    var isRunning: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSave.layer.cornerRadius = 20
        
        tfTitle.text = task.value(forKey: "name") as? String
        tfDetail.text = task.value(forKey: "detail") as? String
        
        datePicker.minimumDate = Date()
        
        if let date: Date = task.value(forKey: "date") as? Date {
            datePicker.setDate(date, animated: true)
        }
            
        progressView.progress = 0
        
        // Do any additional setup after loading the view.
    }
    
    @objc func updateProgressView() {
        progressView.progress += 0.1
        progressView.setProgress(progressView.progress,
                                 animated: true)
        
        if progressView.progress == 1.0 {
            timer?.invalidate()
            isRunning = false
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    @IBAction func userChangedValue(_ sender: UIDatePicker) {
        print(#function)
        print(sender.date)
    }
    

    @IBAction func userTappedSave(_ sender: Any) {
        guard let appDelagate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelagate.persistentContainer.viewContext
        
        do {
            task.setValue(tfTitle.text, forKey: "name")
            task.setValue(tfDetail.text, forKey: "detail")
            task.setValue(datePicker.date, forKey: "date")
            
            try managedContext.save()
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        if isRunning {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 0.3,
                                     target: self,
                                     selector: #selector(updateProgressView),
                                     userInfo: nil,
                                     repeats: true)
        isRunning = true
        
    }
    
    @IBAction func userTappedMap(_ sender: Any) {
        print(#function)
        performSegue(withIdentifier: "seeMap", sender: nil)
        
    }
    
    
}
