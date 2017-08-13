//
//  cameravc3.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/26/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class CameraVC3: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate{
    
    var imgPip: ImagePipView!
    var containerView: UIView!
    
    var photoImageView = UIImageView(frame: CGRect(x: 40, y: 120, width: 200, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoImageView.backgroundColor = UIColor.green
        _mainPipDirectory.registerViewController2(self)
        
        self.view.addSubview(photoImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    // : refactor later. double added
//    func addPipView(pipView: BasePipView) {
////        pipView.addGestureRecognizer(UITapGestureRecognizer(target: pipView, action: "capture:"))
//        println("addpipView of cameraVC3")
//        containerView.addSubview(pipView)
//        containerView.bringSubviewToFront(pipView)
//    }
    
    var beenHereBefore = false
    
    override func viewDidAppear(_ animated: Bool) {
        if beenHereBefore{
            /* Only display the picker once as the viewDidAppear: method gets
            called whenever the view of our view controller gets displayed */
            return;
        } else {
            beenHereBefore = true
        }
        
        print("capture")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            print("Button capture")
            
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            print("post button capture")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        
        print("after camera vc3 will appear")
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Picker was cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("camera vc3 view will appear")
        super.viewWillAppear(animated)
    }
    

    // this is called after a photo is taken
    // saves the photo to photoImageView (which is already added to the view)
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [AnyHashable: Any]){
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: false, completion: nil)
    }
    

func capture(_ tap: UITapGestureRecognizer) {
    print("capture")
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
        print("Button capture")
        
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        print("post button capture")
        
        self.present(imagePicker, animated: true, completion: nil)
    }
}
    
}
    
