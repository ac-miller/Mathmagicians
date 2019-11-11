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

class encounterController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var countdownLbl: UILabel!
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerA: UIButton!
    @IBOutlet var answerB: UIButton!
    @IBOutlet var answerC: UIButton!
    @IBOutlet var answerD: UIButton!
    

    
    //for question/answers
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Questions.plist")
    var questionArray = [Question]()
    var correctAnswer : String?
    
    //for timer functionality
    var countDown = 15
    var timer = Timer()
    
    
    //for alert code when user runs out of time
    func createAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in self.performSegue(withIdentifier:
            "backToMap", sender: self)
            
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
        answerA.setTitle(ques.answers![0].answerText, for: .normal)
        answerB.setTitle(ques.answers![1].answerText, for: .normal)
        answerC.setTitle(ques.answers![2].answerText, for: .normal)
        answerD.setTitle(ques.answers![3].answerText, for: .normal)
        
    }
    
    
    @IBAction func testCorrect(_ sender: UIButton) {
        if (sender.currentTitle == correctAnswer) {
            //display success message
            createAlert(title: "SUCCESS!", message: "You got that one right!")
            //add to inventory
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
            
            performSegue(withIdentifier: "backToMap", sender: nil)
        }
    }
    
    func addBeastie(){

        guard let beastieScene = SCNScene(named: "art.scnassets/dragon.scn") else{
            return
        }

        guard let beastieNode = beastieScene.rootNode.childNode(withName: "dragon", recursively: false) else{
            return
        }

        beastieNode.position = SCNVector3(x: 0, y: 0.1, z: -0.2)

        sceneView.scene.rootNode.addChildNode(beastieNode)

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
