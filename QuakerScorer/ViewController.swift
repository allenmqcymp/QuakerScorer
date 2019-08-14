//
//  ViewController.swift
//  AVCaptureTutorial
//
//  Created by Mike Fu on 7/31/19.
//  Copyright © 2019 Mike Fu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    @IBOutlet weak var captureButton: UIButton!
    
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    
    var takePhoto = false
    var takenPhoto: UIImage?
    
    var captureDevice:AVCaptureDevice!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareCamera()
    }

    func prepareCamera(){
        // select best config for photo capture
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        // check if device is available for photo capture
        if let availbleDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            captureDevice = availbleDevice
            beginSession()
        }
        
    }
    
    func beginSession(){
        
        // user must accept access
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        (self.previewLayer as! AVCaptureVideoPreviewLayer).videoGravity = AVLayerVideoGravity.resizeAspectFill    // fill up screen
        
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.layer.frame
        self.view.addSubview(captureButton)
        captureSession.startRunning()
            
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        
        // drop late video frames for performance
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        // commit configs
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "my queue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        
        self.takePhoto = true
//        performSegue(withIdentifier: "SegueToNav", sender: sender)
//        if let image = takenPhoto {
//            let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
//
//            photoVC.takenPhoto = image
//        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if takePhoto {
            takePhoto = false
            
            // get image from sample buffer
            if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
                
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController

                photoVC.takenPhoto = image
                
                let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavVC") as! NavigationViewController
                navVC.pushViewController(photoVC, animated: true)
                DispatchQueue.main.async {
                    self.present(navVC, animated: true, completion: {
                        self.stopCaptureSession()       // stop the capture session as soon as view controller is presented
                    })
                }
            }
        }
        
    }
    
    // get image from sample buffer
    func getImageFromSampleBuffer(buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvImageBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        
        return nil
    }
    
    func stopCaptureSession() {
        self.captureSession.stopRunning()
        
        // can only have one input to device
        if let inputs = captureSession.inputs as?  [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
    }

}

