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
        trunk.firstMaterial?.diffuse.contents = UIColor.brown
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
