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
        addRotateUFO()
        addRoofLights()
        
    }
    
    func lightNode(position: SCNVector3) -> SCNNode {
        let light = SCNLight()
        light.type = .omni
        light.color = UIColor(red:1.00, green:0.99, blue:0.71, alpha:1.00)
        light.castsShadow = true
        light.intensity = 0.05
        light.attenuationStartDistance = 0
        light.attenuationEndDistance = 0.5
        
        let lightNode = SCNNode(geometry: SCNSphere(radius: 0.02))
        lightNode.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        lightNode.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.physicallyBased
        lightNode.light = light
        lightNode.position = position

        return lightNode
    }
    
    func addRoofLights() {
        let step: Float = 3.8
        let startPosition: Float = -3.8
        for x in 0..<5 {
            mainNode().addChildNode(lightNode(position: SCNVector3(x: (startPosition + Float(x) * step), y: 5.03, z: -1.2)))
            mainNode().addChildNode(lightNode(position: SCNVector3(x: (startPosition + Float(x) * step), y: 5.03, z: -2.8)))
        }
    }
    
    func addRotateUFO() {
        let ufoScene = SCNScene(named: "art.scnassets/UFO.scn")!
        
        let ufo = ufoScene.rootNode.childNode(withName: "ufo", recursively: false)
        ufo?.scale = SCNVector3(x: 0.3, y: 0.3, z: 0.3)
        ufo?.pivot = SCNMatrix4MakeTranslation(0, 1.5, 4)
        
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 2 * Float.pi))
        spin.duration = 3
        spin.repeatCount = .infinity
        ufo?.addAnimation(spin, forKey: "spin around")
      
        let ufoNode = SCNNode()
        ufoNode.position = SCNVector3(0.5, 6, 3)
        ufoNode.eulerAngles = SCNVector3(Float.pi/2/3, Float.pi/2/3, 0)
        ufoNode.addChildNode(ufo!)
        mainNode().addChildNode(ufoNode)
        
        let light = SCNLight()
        light.type = .omni
        light.color = UIColor.yellow
        light.castsShadow = true
        light.intensity = 3
        
        light.attenuationStartDistance = 0
        light.attenuationEndDistance = 2
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0, y: 7.5, z: 3)
        mainNode().addChildNode(lightNode)
        
        let lightRay = SCNLight()
        lightRay.type = .spot
        lightRay.color = UIColor(red:1.00, green:0.98, blue:0.59, alpha:1.00)
        lightRay.castsShadow = true
        lightRay.spotInnerAngle = 8
        lightRay.spotOuterAngle = 8
        lightRay.intensity = 1
        let lightRayNode = SCNNode()
        lightRayNode.light = lightRay
        lightRayNode.opacity = 0.5
        lightRayNode.position = SCNVector3(0.5, 5.9, 3)
        lightRayNode.eulerAngles = SCNVector3(-Float.pi/2, 0, 0)
        mainNode().addChildNode(lightRayNode)
        
        let rayConeNode = SCNNode(geometry: SCNCone(topRadius: 0.2, bottomRadius: 0.4, height: 6))
        rayConeNode.geometry?.firstMaterial?.diffuse.contents = UIColor(red:1.00, green:0.98, blue:0.59, alpha:1.00)
        rayConeNode.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.physicallyBased
        rayConeNode.opacity = 0.2
        rayConeNode.position = SCNVector3(0.5, 3, 3)
        mainNode().addChildNode(rayConeNode)
        
        
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
    
    
    
    func getTree(position: SCNVector3) -> SCNNode {
        let nodeTree = SCNNode()
        nodeTree.position = position
        
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
        
        mainNode.addChildNode(getTree(position: SCNVector3(-4.5, 0, 4.5)))
        mainNode.addChildNode(getTree(position: SCNVector3(-4.5, 0, -4.5)))
        mainNode.addChildNode(getTree(position: SCNVector3(4.5, 0, -4.5)))
        mainNode.addChildNode(getTree(position: SCNVector3(4.5, 0, 4.5)))
        
        mainNode.addChildNode(getTree(position: SCNVector3(-4.5, 0, -1.5)))
        mainNode.addChildNode(getTree(position: SCNVector3(-4.5, 0, 1.5)))

        mainNode.addChildNode(getTree(position: SCNVector3(4.5, 0, -1.5)))
        mainNode.addChildNode(getTree(position: SCNVector3(4.5, 0, 1.5)))

        mainNode.addChildNode(getTree(position: SCNVector3(-1.5, 0, -4.5)))
        mainNode.addChildNode(getTree(position: SCNVector3(1.5, 0, -4.5)))

    }
    
    func getSpruce(position: SCNVector3)  -> SCNNode {
        let nodeSpruce = SCNNode()
        nodeSpruce.position = position

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
            mainNode.addChildNode(getSpruce(position: SCNVector3(1, 0, index)))
            mainNode.addChildNode(getSpruce(position: SCNVector3(-1, 0, index)))
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
