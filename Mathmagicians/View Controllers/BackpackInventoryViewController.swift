//
//  BackpackInventoryViewController.swift
//  Mathmagicians
//
//  Created by Aaron Miller on 10/31/19.
//  Copyright © 2019 Jesse Chan. All rights reserved.
//

import UIKit
import Firebase

class BackpackInventoryViewController: UIViewController {

    let userID = Auth.auth().currentUser?.uid
    var ref = Database.database().reference()
    
    var beasties: [BackpackCell] = [BackpackCell]()
    
    @IBOutlet var beastieTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveData()
        beastieTable.dataSource = self
        beastieTable.register(UINib(nibName: "BeastieBackpackCell", bundle: nil), forCellReuseIdentifier: "BeastieCell")

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let childRef = self.ref.child("users/\(userID!)/beasties/")
        childRef.removeAllObservers()
    }
    
    func retrieveData() {
        
        let childRef = self.ref.child("users/\(userID!)/beasties/")
        
        childRef.observe(.childAdded) { (snapshot) in
            let snapVal = snapshot.value as! Dictionary<String,String>
            let name = snapVal["beastie"]
            let ques = snapVal["question"]
            let ans = snapVal["answer"]

            let newCell = BackpackCell()
            newCell.beastie = name ?? ""
            newCell.question = ques ?? ""
            newCell.answer = ans ?? ""
            self.beasties.append(newCell)
            self.beastieTable.reloadData()
        }
    }

}

extension BackpackInventoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beasties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = beastieTable.dequeueReusableCell(withIdentifier: "BeastieCell", for: indexPath) as! BeastieBackpackCell
        cell.beastieName.text = beasties[indexPath.row].beastie
        cell.questionLabel.text = beasties[indexPath.row].question
        cell.answerLabel.text = beasties[indexPath.row].answer
        return cell
    }
    
}
