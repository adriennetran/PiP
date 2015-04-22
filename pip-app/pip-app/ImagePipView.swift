
//
//  ImagePip.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/21/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

// Create a subview which is the "images directory"

class ImagePipView: BasePipView{
    
    // required stuff.
    required init(coder aDecoder: NSCoder){
        fatalError("coder initializer not coded")
    }
    
    init(point: CGPoint, id: Int){
        super.init(point: point, image: UIImage(named: "imagePip-image")!, id: id)
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width + 120, self.frame.height)
        
        pipInputView.frame = CGRectMake(frame.width-60, 0, 60, frame.height)
        pipOutputView.frame = CGRectMake(0, 0, 60, frame.height)
    }
    
    // accessors
    override func getModel() -> BasePip {
        return _mainPipDirectory.getPipByID(pipId).model
    }
    
    // takes image data chosen by user
    func getLocalImage(image: UIImage){
        
    }
    
    override func updateView(){
        (getModel() as? ImagePip)?.updateReliantPips()
    }
    
    
}
