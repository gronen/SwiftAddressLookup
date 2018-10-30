//
//  ViewController.swift
//  MapSearch
//
//  Created by Galit Ronen on 10/29/18.
//  Copyright © 2018 Consult Partners US. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MapNetworkManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTextField : UITextField?
    @IBOutlet weak var choicesTableView : UITableView?

    var networkManager = MapNetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        
        loadTableView()
    }
    
    func loadTableView() {
        guard let tableView = choicesTableView else {
            return // tableView is empty
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mapCell")
        
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.borderWidth = 1
        
        tableView.sizeToFit()
        tableView.layoutIfNeeded()
    }
    
    @IBAction func clearTextField(_ sender: Any) {
        guard let textField = searchTextField else {
            return
        }
        textField.text = ""
        networkManager.clearValues() // a value was cleared, clear the options
        self.reloadTableView()
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        guard let textInput = searchTextField?.text else {
            return
        }
        networkManager.getAutoCompletePredictions(input: textInput)
    }
    
    func reloadTableView() {
        guard let tableView = self.choicesTableView else {
            print("table was empty.")
            return
        }
        tableView.reloadData()
        if self.networkManager.predictionArray.count < 1 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            tableView.sizeToFit()
            var tableFrame = tableView.frame
            tableFrame.size.height = CGFloat(44 * self.networkManager.predictionArray.count)
            tableView.frame = tableFrame
        }
        tableView.layoutIfNeeded()
    }
    
    func didFinishDownloading() {
        DispatchQueue.main.async {
            self.reloadTableView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.networkManager.predictionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MapTableViewCell? = MapTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "mapCell")
        
        guard let mapCell = cell else {
            return UITableViewCell() // cell is empty
        }
        
        guard let textView = mapCell.textView else {
            return mapCell
        }
        
        textView.text = networkManager.predictionArray[indexPath.row]
        
        return mapCell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let textField = searchTextField else {
            print("Unable to update textfield.")
            return indexPath
        }
        textField.text = networkManager.predictionArray[indexPath.row]
        networkManager.clearValues() // a value was selected, clear the options
        self.didFinishDownloading()
        return indexPath
    }

}

