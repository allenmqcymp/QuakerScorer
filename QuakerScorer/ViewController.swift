//
//  ViewController.swift
//  QuakerScorer
//
//  Created by home1 on 1/07/19.
//  Copyright © 2019 home1. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    var requests = [VNRequest]()
    @IBOutlet weak var mainImageView: UIImageView!
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    let settings = AVCapturePhotoSettings()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
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
    }
//
//    // creates a request that looks for text in rectangles
//    func startTextDetection() {
//        print("starting text detection")
////        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
//        let textRequest = VNDetectTextRectanglesRequest(completionHandler: { (request, error) in
//            print("helloooooo")
//            guard let results = request.results else {
//                print("no results :(")
//                return
//            }
//        })
//        textRequest.reportCharacterBoxes = true
//        self.requests = [textRequest]
//    }
//
//    // highlights letters
//    func highlightLetters(box: VNRectangleObservation) {
//        let xCord = box.topLeft.x * mainImageView.frame.size.width
//        let yCord = (1 - box.topLeft.y) * mainImageView.frame.size.height
//        let width = (box.topRight.x - box.bottomLeft.x) * mainImageView.frame.size.width
//        let height = (box.topLeft.y - box.bottomLeft.y) * mainImageView.frame.size.height
//
//        let outline = CALayer()
//        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
//        outline.borderWidth = 1.0
//        outline.borderColor = UIColor.blue.cgColor
//
//        mainImageView.layer.addSublayer(outline)
//    }
//
//    func detectTextHandler(request: VNRequest, error: Error?) {
//        print("detecting text")
//        guard let observations = request.results else {
//            print("no result")
//            return
//        }
//
//        let result = observations.map({$0 as? VNTextObservation})
//
//        DispatchQueue.main.async() {
//            self.mainImageView.layer.sublayers?.removeSubrange(1...)
//            for region in result {
//                guard let rg = region else {
//                    continue
//                }
//
//                if let boxes = region?.characterBoxes {
//                    for characterBox in boxes {
//                        self.highlightLetters(box: characterBox)
//                        print("highlight")
//                    }
//                }
//            }
//        }
//    }
    
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSession.Preset.photo
        
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            stillImageOutput = AVCapturePhotoOutput()
            settings.livePhotoVideoCodecType = .jpeg
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity =    AVLayerVideoGravity.resizeAspect
                videoPreviewLayer!.connection?.videoOrientation =   AVCaptureVideoOrientation.portrait
                mainImageView.layer.addSublayer(videoPreviewLayer!)
                session!.startRunning()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
