//
//  encounterController.swift
//  Mathmagicians
//
//  Created by Jesse Chan on 11/3/19.
//  Copyright © 2019 Jesse Chan. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import SwiftUI
import Firebase

class EncounterController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var countdownLbl: UILabel!
    
    @IBOutlet var questionContainer: UIView!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerA: UIButton!
    @IBOutlet var answerB: UIButton!
    @IBOutlet var answerC: UIButton!
    @IBOutlet var answerD: UIButton!
    
    //for cloud storage
    var ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    //for question/answers
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Questions.plist")
    var questionArray = [Question]()
    var correctAnswer : String?
    var beastie : Beastie?
    
    //for timer functionality
    var countDown = 15
    var timer = Timer()
    
    //for alert code when user runs out of time
    func createAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in self.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()

        sceneView.delegate = self

        sceneView.showsStatistics = true

        let scene = SCNScene()

        sceneView.scene = scene
        
        showQuestion()
        
        //start timer
        startCountDown()
        
       
        addBeastie()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //styles questions and answers, and populates
    func showQuestion() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                questionArray = try decoder.decode([Question].self, from: data)
            } catch {
                print("Error decoding questions from plist")
            }
        }
        
        let questionIndex = Int.random(in: 0 ..< questionArray.count)
        
        questionLabel.text = questionArray[questionIndex].questionText
        
        showAnswers(for: questionArray[questionIndex])
        
    }
    func showAnswers(for ques: Question) {
        //sets which answer is true
        for answer in ques.answers! {
            if answer.correct == true {
                correctAnswer = answer.answerText
            }
        }
        let ind = [0, 1, 2, 3].shuffled()
        answerA.setTitle(ques.answers![ind[0]].answerText, for: .normal)
        answerB.setTitle(ques.answers![ind[1]].answerText, for: .normal)
        answerC.setTitle(ques.answers![ind[2]].answerText, for: .normal)
        answerD.setTitle(ques.answers![ind[3]].answerText, for: .normal)
        formatAnswer(button: answerA)
        formatAnswer(button: answerB)
        formatAnswer(button: answerC)
        formatAnswer(button: answerD)
        
    }
    
    func formatAnswer(button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: questionContainer.widthAnchor, multiplier: 0.4).isActive = true
    }
    
    
    @IBAction func testCorrect(_ sender: UIButton) {
        
        timer.invalidate()
        
        if (sender.currentTitle == correctAnswer) {
            //display success message
            createAlert(title: "SUCCESS!", message: "You got that one right!")
            //add to inventory
            let beastieToShow = ["beastie": beastie!.arImagePath!,
                           "question": questionLabel.text,
                           "answer": correctAnswer]
            guard let key = self.ref.child("users/\(userID!)/beasties").childByAutoId().key else {return}
            let childUpdate = ["users/\(userID!)/beasties/\(key)/": beastieToShow]
            self.ref.updateChildValues(childUpdate)
        }
        else {
            //display failure message
            createAlert(title: "OH NO!", message: "The correct answer is \(correctAnswer ?? "not displayed")")
        }
    }
    
    
    //func to initialize timer
    func startCountDown(){
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownMethod), userInfo: nil, repeats: true)
    }
    
    @objc func countDownMethod(){
        countDown -= 1
        countdownLbl.text = "\(countDown)"
        
        //stop timer when it reaches 0 seconds
        if (countDown == 0)
        {
            timer.invalidate()
            createAlert(title: "MATHMAGICIAN, YOU RAN OUT OF TIME!", message: "We're taking you back to the map")
            
            
            //duplicate segue function
            //performSegue(withIdentifier: "backToMap", sender: nil)
        }
    }
    
    func addBeastie(){

        let beastiePath = beastie!.arImagePath
        
        let beastieScene = SCNScene(named: beastiePath! + ".scn", inDirectory: "art.scnassets/")
        
        let beastieNode = beastieScene!.rootNode.childNode(withName: beastiePath!, recursively: false)

        beastieNode!.position = SCNVector3(x: 0, y: 0.1, z: -0.2)

        sceneView.scene.rootNode.addChildNode(beastieNode!)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}
