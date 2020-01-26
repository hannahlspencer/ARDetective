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
    
    var availableClues = ["hair", "footprint", "nail clipping"]
    var foundClues: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
    }
    

    @IBAction func scanForClues(_ sender: Any) {
        if(availableClues.isEmpty) {
            //dialogbox.isHidden = false
            //dialogbox.text = "You found all the clues! Review your evidence or accuse one of the suspects!"
            //scanButton.isHidden = true (or greyed out)
        } else {
            //pick random clue to use
            let clue = pickRandomClue()
            
            //checkformovement
        }
    }
    
    func pickRandomClue() -> String{
        let clue = availableClues.randomElement()!
        if let index = availableClues.firstIndex(of: clue) {
            availableClues.remove(at: index)
        }
        foundClues.append(clue)
        return clue
    }
    
    func addNode(clueNode: SCNNode) {
        cameraPosition = sceneView.pointOfView?.position
        clueNode.scale = SCNVector3(0, 0, 0)
        clueNode.isPaused = true
        clueNode.position = setPosition(clueNode: clueNode)
    
        self.sceneView.scene.rootNode.addChildNode(clueNode)
        fadeIn(node: clueNode)
    }
    
    func checkForMovement(clueNode: SCNNode) {
            let currentPosition = sceneView.pointOfView?.position
            let x: Float = (currentPosition?.x ?? 0) - cameraPosition.x
            let y: Float = (currentPosition?.y ?? 0) - cameraPosition.y
            let z: Float = (currentPosition?.z ?? 0) - cameraPosition.z
            let difference: Float = x + y + z
            //playSoundEffect(name: "scan")
            let time = DispatchTime.now() + 1.0
            DispatchQueue.main.asyncAfter(deadline:time){
                //and randomise
                if(difference < 0.5 && difference > -0.5) {
//                    self.sayLine(lineNum: 0, line: "Nothing here. Try a different part of your room")
//                    self.scriptLineNumber -= 1
                    //dialogbox.isHidden = false
                    //dialogbox.text = "Nothing here. Try a different part of your room"
                } else {
                    //dialogbox.isHidden = false
                    //dialogbox.text = "You found a clue! Let's examine it"
                    //scanButton.text = "Examine"
                    
                    //addNode(clue)
                    //add clue to evidence locker
                    //play some sort of sound

                }
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
        if(node.name == "flag") {
            node.scale = SCNVector3(0.03, 0.03, 0.03)
        }
    }
}
