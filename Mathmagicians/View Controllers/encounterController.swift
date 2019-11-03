//
//  encounterController.swift
//  Mathmagicians
//
//  Created by Jesse Chan on 11/3/19.
//  Copyright © 2019 Jesse Chan. All rights reserved.
//

import UIKit
import ARKit

class encounterController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        sceneView.delegate = self

        sceneView.showsStatistics = true

        let scene = SCNScene()

        sceneView.scene = scene
        
        addBeastie()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func addBeastie(){

        guard let beastieScene = SCNScene(named: "art.scnassets/dragon.scn") else{
            return
        }

        guard let beastieNode = beastieScene.rootNode.childNode(withName: "dragon", recursively: false) else{
            return
        }

        beastieNode.position = SCNVector3(x: 0, y: 0.5, z: -3)

        sceneView.scene.rootNode.addChildNode(beastieNode)

    }
}
