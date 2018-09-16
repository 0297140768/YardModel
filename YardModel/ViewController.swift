//
//  ViewController.swift
//  YardModel
//
//  Created by Татьяна on 14.09.2018.
//  Copyright © 2018 Татьяна. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        loadYard()
        trees()
        spruces()
        rotateUFO()
        
    }
    
    func rotateUFO() {
        let ufo = mainNode().childNode(withName: "ufo", recursively: false)
        
        ufo?.pivot = SCNMatrix4MakeTranslation(0, 1.5, 4)
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 2 * Float.pi))
        spin.duration = 3
        spin.repeatCount = .infinity
        ufo?.addAnimation(spin, forKey: "spin around")
        
    }
    
    func loadYard()  {
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/yard.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene

    }
    
    func mainNode() -> SCNNode {
        for node in sceneView.scene.rootNode.childNodes {
            if node.name == "yard" {
                return node
            }
        }
        return SCNNode()
    }
    
    
    
    func getTree(positin: SCNVector3) -> SCNNode {
        let nodeTree = SCNNode()
        nodeTree.position = positin
        
        let nodeTrunk = SCNNode()
        nodeTrunk.position = SCNVector3(0, 0.75, 0)
        let trunk = SCNCylinder(radius: 0.05, height: 1.5)
        trunk.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/trunk1.jpg")
        trunk.firstMaterial?.lightingModel = SCNMaterial.LightingModel.physicallyBased

        nodeTrunk.geometry = trunk
        
        let nodeCrown = SCNNode()
        nodeCrown.position = SCNVector3(0, 1.5, 0)
        nodeCrown.scale = SCNVector3(1, 2, 1)
        let crown = SCNSphere(radius: 0.3)
        crown.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/crown1.jpg")
        crown.firstMaterial?.lightingModel = SCNMaterial.LightingModel.physicallyBased
        nodeCrown.geometry = crown
        
        nodeTree.addChildNode(nodeCrown)
        nodeTree.addChildNode(nodeTrunk)

        return nodeTree
    }
    
    func trees() {
        let mainNode = self.mainNode()
        
        mainNode.addChildNode(getTree(positin: SCNVector3(-4.5, 0, 4.5)))
        mainNode.addChildNode(getTree(positin: SCNVector3(-4.5, 0, -4.5)))
        mainNode.addChildNode(getTree(positin: SCNVector3(4.5, 0, -4.5)))
        mainNode.addChildNode(getTree(positin: SCNVector3(4.5, 0, 4.5)))
        
        mainNode.addChildNode(getTree(positin: SCNVector3(-4.5, 0, -1.5)))
        mainNode.addChildNode(getTree(positin: SCNVector3(-4.5, 0, 1.5)))

        mainNode.addChildNode(getTree(positin: SCNVector3(4.5, 0, -1.5)))
        mainNode.addChildNode(getTree(positin: SCNVector3(4.5, 0, 1.5)))

        mainNode.addChildNode(getTree(positin: SCNVector3(-1.5, 0, -4.5)))
        mainNode.addChildNode(getTree(positin: SCNVector3(1.5, 0, -4.5)))

    }
    
    func getSpruce(positin: SCNVector3)  -> SCNNode {
        let nodeSpruce = SCNNode()
        nodeSpruce.position = positin

        let nodeTrunk = SCNNode()
        nodeTrunk.position = SCNVector3(0, 1, 0)
        let trunk = SCNCylinder(radius: 0.15, height: 2)
        trunk.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/trunk1.jpg")
        
        nodeTrunk.geometry = trunk
        
        let nodeLowerCone = SCNNode()
        nodeLowerCone.position = SCNVector3(0, 1, 0)
        var cone = SCNCone(topRadius: 0, bottomRadius: 1, height: 1.5)
        cone.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/spruce1.jpeg")
        cone.firstMaterial?.lightingModel = SCNMaterial.LightingModel.physicallyBased
        nodeLowerCone.geometry = cone
        
        
        let nodeMiddleCone = SCNNode()
        nodeMiddleCone.position = SCNVector3(0, 1.8, 0)
        cone = SCNCone(topRadius: 0, bottomRadius: 0.8, height: 1.5)
        cone.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/spruce1.jpeg")
        cone.firstMaterial?.lightingModel = SCNMaterial.LightingModel.physicallyBased
        nodeMiddleCone.geometry = cone

        let nodeUpperCone = SCNNode()
        nodeUpperCone.position = SCNVector3(0, 2.4, 0)
        cone = SCNCone(topRadius: 0, bottomRadius: 0.55, height: 1)
        cone.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/spruce1.jpeg")
        cone.firstMaterial?.lightingModel = SCNMaterial.LightingModel.physicallyBased
        nodeUpperCone.geometry = cone

        nodeSpruce.addChildNode(nodeTrunk)
        nodeSpruce.addChildNode(nodeLowerCone)
        nodeSpruce.addChildNode(nodeMiddleCone)
        nodeSpruce.addChildNode(nodeUpperCone)

        nodeSpruce.scale = SCNVector3(0.4, 0.5, 0.4)
        
        return nodeSpruce
        
    }
    
    func spruces()  {
        let mainNode = self.mainNode()
        
        for index in  [-0.5,2,4.5] {
            mainNode.addChildNode(getSpruce(positin: SCNVector3(1, 0, index)))
            mainNode.addChildNode(getSpruce(positin: SCNVector3(-1, 0, index)))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
