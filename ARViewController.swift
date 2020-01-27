//
//  ARViewController.swift
//  ARDetective
//
//  Created by Hannah Spencer on 25/01/2020.
//  Copyright © 2020 Hannah Spencer. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class ARViewController: UIViewController {

    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var cameraPosition: SCNVector3!
    var cameraRotation: SCNVector4!
        
    @IBOutlet weak var dialogBox: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    var availableClues: Array<String> = ["hair", "footprint", "button"]
    var foundClues: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
        dialogBox.isHidden = true
    }
    
    @IBAction func scanForClues(_ sender: Any) {
        print(availableClues.count)
        if(availableClues.isEmpty) {
            dialogBox.isHidden = false
            dialogBox.text = "You found all the clues! Review your evidence or accuse one of the suspects!"
            //scanButton.isHidden = true (or greyed out)
        } else {
            let clue = createNode(name: pickRandomClue())!
            checkForMovement(clueNode: clue)
            
        }
    }
    
    func pickRandomClue() -> String{
        let clue = availableClues.randomElement()!
        return clue
    }
    
    func createNode(name: String) -> SCNNode? {
        let germScene = SCNScene(named: name + ".scn")
        return germScene?.rootNode.childNode(withName: name, recursively: false)
    }
    
    func addNode(clueNode: SCNNode) {
        
        clueNode.scale = SCNVector3(0, 0, 0)
        clueNode.isPaused = true
        clueNode.position = setPosition(clueNode: clueNode)
    
        self.sceneView.scene.rootNode.addChildNode(clueNode)
        fadeIn(node: clueNode)
    }
    
    func checkForMovement(clueNode: SCNNode) {
        var difference: Float!
        if(cameraPosition != nil) {
            cameraPosition = sceneView.pointOfView?.position
            let currentPosition = sceneView.pointOfView?.position
            let x: Float = (currentPosition?.x ?? 0) - cameraPosition.x
            let y: Float = (currentPosition?.y ?? 0) - cameraPosition.y
            let z: Float = (currentPosition?.z ?? 0) - cameraPosition.z
            difference = x + y + z
        } else {
            difference = 1.0
        }
        
        //playSoundEffect(name: "scan")
        let time = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline:time) {
            let odds = Float.random(in: 0 ..< 1)
            if(odds > 0.7 || (difference < 0.5 && difference > -0.5)) {
                self.dialogBox.isHidden = false
                self.dialogBox.text = "Nothing here. Try somewhere else"
            } else {
                //play some sort of sound
                self.dialogBox.isHidden = false
                self.dialogBox.text = "You found a clue! Let's examine it"
                self.scanButton.setTitle("Examine", for: .normal)
                if let index = self.availableClues.firstIndex(of: clueNode.name!) {
                    self.availableClues.remove(at: index)
                }
                self.foundClues.append(clueNode.name!)
                self.examineClue(clue: clueNode)
            }
        }
    }
    
    func examineClue(clue: SCNNode) {
        addNode(clueNode: clue)
        scanButton.setTitle("Scan", for: .normal)
        let name: String = clue.name ?? "Clue name broke"
        dialogBox.text = "You found a \(name) from the murderer! This clue has been added to your evidence. Click Scan again to keep looking."
        
        switch name {
            case "hair":
            Evidence.hair = true
            case "footprint":
            Evidence.footprint = true
            case "button":
            Evidence.button = true
            default:
            print("Clue switch case went wrong, name provided was \(name)")
        }
        
    }
    
    func setPosition(clueNode: SCNNode) -> SCNVector3 {
        cameraRotation = sceneView.pointOfView!.rotation
        var x = (sceneView.pointOfView?.position.x)!
        let y = (sceneView.pointOfView?.position.y)! - 0.5
        var z = (sceneView.pointOfView?.position.z)! - 0.5
            //still not quite there
            
        if(cameraRotation.y < -0.5 && (cameraRotation.w < 2 || cameraRotation.w > 4)) {
            x += 0.5
            z += (cameraRotation.w - 1)
        } else if(cameraRotation.y > 0.5 && (cameraRotation.w < 2 || cameraRotation.w > 4)) {
            x -= 0.5
            z += (cameraRotation.w - 1)
        } else if(cameraRotation.w > 2 && cameraRotation.w < 4) {
            z += 1
            }
            return SCNVector3(x, y, z)
        }

    func fadeIn(node: SCNNode!) {
        SCNTransaction.animationDuration = 3.0
        node.scale = SCNVector3(0.07, 0.07, 0.07)
    }
}

