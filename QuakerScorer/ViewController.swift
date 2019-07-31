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
