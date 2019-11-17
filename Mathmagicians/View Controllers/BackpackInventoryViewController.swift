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

    var beasties: [BackpackCell] = [
        BackpackCell(beastie: "dragon", question: "1+1", answer: "2"),
        BackpackCell(beastie: "cat", question: "2+2", answer: "4"),
        BackpackCell(beastie: "scary", question:"4+4", answer: "8")
    ]
    
    @IBOutlet var beastieTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beastieTable.dataSource = self
        beastieTable.register(UINib(nibName: "BeastieBackpackCell", bundle: nil), forCellReuseIdentifier: "BeastieCell")

    }
    
    //need to get beasties caught from firebase or core data

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
