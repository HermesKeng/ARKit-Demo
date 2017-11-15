//
//  ViewController.swift
//  ARSceneKit
//
//  Created by 耿楷寗 on 15/11/2017.
//  Copyright © 2017 EIE. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addBox()
        addTapGestureToSceneView()
        
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBox(x: Float = 0,y: Float = 0,z:Float = 0 ){
        let box = SCNBox(width:0.05,height:0.05,length:0.1,chamferRadius:0) //.1 Float = 1 meter
        let boxMode = SCNNode() // we create a node. A node represents the position and the coordinate of an object in 3D space
        boxMode.geometry = box // we are going to setting the geometry to the box
        boxMode.position = SCNVector3(x,y,z) // See the example picture
        
        let scene = SCNScene()
        sceneView.scene.rootNode.addChildNode(boxMode)
    }
    func addTapGestureToSceneView(){
        let tapGestureRecognizer = UITapGestureRecognizer(target:self,action:#selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recongnizer:UIGestureRecognizer){
        let tapLocation = recongnizer.location(in: sceneView) // get the tap location in the scene view
        let hitTestResults = sceneView.hitTest(tapLocation)
        
        guard let node = hitTestResults.first?.node else{ // to know whether touch the node in the sceneView, if it is then remove it
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            // if we don't detect the box where we tap, then we are going to add the box
            if let hitTestResultWithFeaturePoint = hitTestResultsWithFeaturePoints.first{
                let translation = hitTestResultWithFeaturePoint.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode() // remove the box from the node
    }
}
extension float4x4{
    var translation:float3{
        let translation = self.columns.3
        return float3(translation.x,translation.y,translation.z)
    }
}

