//
//  HistoryViewController.swift
//  SimpleCalc-iOS
//
//  Created by Jake Jin on 10/21/18.
//  Copyright © 2018 Jake Jin. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource {

    public var data:Array<String> = []

    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        print (data)
//        let myData = Data(data)
//        tableview.dataSource = myData
//        print(myData.data)
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "HISTORY"
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//class Data: NSObject, UITableViewDataSource {
//    var data:[String]
//    init(_ data: [String]){
//        self.data = data
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.textLabel?.text = data[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "HISTORY"
//    }
//}

