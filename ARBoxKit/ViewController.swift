//
//  ViewController.swift
//  ARBoxKit
//
//  Created by Ice on 27/3/2562 BE.
//  Copyright © 2562 Ice. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreMotion

class ViewController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet weak var xPosition: UILabel!
    @IBOutlet weak var yPosition: UILabel!
    @IBOutlet weak var zPosition: UILabel!
    
    @IBOutlet var sceneView: ARSCNView!
    let motionManager = CMMotionManager()
    let geometry: SCNGeometry? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager.startAccelerometerUpdates()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
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

    ///TabGesture
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //let touch = touches.first
        //let location = touch?.location(in: sceneView)
        
//        let hitResults = sceneView.hitTest(location!, types: .featurePoint)
//
//        if let hitTestResult = hitResults.first {
//            let transform = hitTestResult.worldTransform
//
            print("Touch")
            //let position = SCNVector3(x: transform.columns.3.x , y: transform.columns.3.y, z: transform.columns.3.z)

            let positionTwo = SCNVector3(x: Float(self.motionManager.accelerometerData?.acceleration.x ?? 0),
                                         y: Float(self.motionManager.accelerometerData?.acceleration.y ?? 0),
                                         z: Float(self.motionManager.accelerometerData?.acceleration.z ?? 0))
        
        let touch = touches.first
        let location = touch?.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location!, types: .featurePoint)
        
        if let hitTestResult = hitResults.first {
            let transform = hitTestResult.worldTransform
            let positionTwo = SCNVector3(x: transform.columns.3.x, y: transform.columns.3.y, z:transform.columns.3.z)
            
            let geometry: SCNGeometry
            geometry = SCNPyramid(width:1.0, height:1.0, length:1.0)
            geometry.materials.first?.diffuse.contents = UIColor.red
            
            
            let geometryNode = SCNNode(geometry: geometry)
            geometryNode.position = positionTwo
            print("Object Position : \(positionTwo)")
            geometryNode.scale = SCNVector3(x:0.1, y:0.1, z:0.1)
            
            sceneView.scene.rootNode.addChildNode(geometryNode)
        }
        

        //}
        
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
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

        DispatchQueue.main.async {
            
            let acceleration = self.motionManager.accelerometerData?.acceleration
            self.xPosition.text = "\(acceleration?.x ?? 0)"
            self.yPosition.text = "\(acceleration?.y ?? 0)"
            self.zPosition.text = "\(acceleration?.z ?? 0)"
        }
    }
    
}
