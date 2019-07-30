//
//  ViewController.swift
//  QuakerScorer
//
//  Created by home1 on 1/07/19.
//  Copyright © 2019 home1. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    var requests = [VNRequest]()
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBAction func captureImageAction(_ sender: Any) {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    // comment comment
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        mainImageView.image = info[.originalImage] as? UIImage
        
        startTextDetection()
    }
    
    // creates a request that looks for text in rectangles
    func startTextDetection() {
        print("starting text detection")
//        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
        let textRequest = VNDetectTextRectanglesRequest(completionHandler: { (request, error) in
            print("helloooooo")
            guard let results = request.results else {
                print("no results :(")
                return
            }
        })
        textRequest.reportCharacterBoxes = true
        self.requests = [textRequest]
    }
    
    // highlights letters
    func highlightLetters(box: VNRectangleObservation) {
        let xCord = box.topLeft.x * mainImageView.frame.size.width
        let yCord = (1 - box.topLeft.y) * mainImageView.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * mainImageView.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * mainImageView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 1.0
        outline.borderColor = UIColor.blue.cgColor
        
        mainImageView.layer.addSublayer(outline)
    }
    
    func detectTextHandler(request: VNRequest, error: Error?) {
        print("detecting text")
        guard let observations = request.results else {
            print("no result")
            return
        }
        
        let result = observations.map({$0 as? VNTextObservation})
        
        DispatchQueue.main.async() {
            self.mainImageView.layer.sublayers?.removeSubrange(1...)
            for region in result {
                guard let rg = region else {
                    continue
                }
                
                if let boxes = region?.characterBoxes {
                    for characterBox in boxes {
                        self.highlightLetters(box: characterBox)
                        print("highlight")
                    }
                }
            }
        }
    }
    
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


}

