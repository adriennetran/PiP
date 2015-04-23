import UIKit
import MobileCoreServices


class CameraViewControllerTest: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoLibraryDelegate{
    
    init() {
        super.init(nibName:nil, bundle:nil)
        var imageView: ImagePipView = ImagePipView(point: CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height/2), id: 24)
        
        var productRequest: ImagePipView = imageView
        productRequest.delegate = self
    }
    
    override init(nibName: String?, bundle: NSBundle?) {
        super.init(nibName:nibName, bundle:bundle)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    var photoImageView = UIImageView(frame: CGRectMake(40, 40, 200, 200))
    
//    @IBAction func btnCamera(sender: AnyObject){
//        if (UIImagePickerController.isSourceTypeAvailable(.Camera)){
//            // load camera interface
//            var picker : UIImagePickerController = UIImagePickerController()
//            picker.sourceType = UIImagePickerControllerSourceType.Camera
//            picker.delegate = self
//            picker.allowsEditing = false
//            picker.presentViewController(picker, animated: true, completion: nil)
//        } else{
//            // no camera available
//            var alert = UIAlertController(title: "ERror", message: "There is no camera available", preferredStyle: .Alert)
//        }
//    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.photoImageView.backgroundColor = UIColor.greenColor()
        self.view.addSubview(photoImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var photoPicker = UIImagePickerController()
    
    func openPhotoLibrary(request: ImagePipView){
        println ("inside photo library")
        var photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary // standards
//        self.presentViewController(photoPicker, animated: true, completion: nil)
//        presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    // something happens when we click a picture
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        println("inside view will appear")
        
        var photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary // standards
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
}