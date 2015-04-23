//
//  ImagePip.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/21/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class ImageOutput{
    var image: UIImage!
    var text: String!

    
    init(){
        // image intializes as null until user adds something
    }
    
    func getImage() -> UIImage{
        return image
    }
    
    func setImage(newImage: UIImage){
        image = newImage
    }
    
    func getText() -> String{
        return text
    }
    
    func setText(newText: String) -> String{
        text = newText
        return text
    }
}

class ImagePip: BasePip{
    
    var output: ImageOutput!
    var cameraVC: cameraViewController!
    
    init(id: Int){
        super.init(pipType: PipType.Accel, id: id)
        output = ImageOutput()
    }
    
    func updateImage(newVal: UIImage){
        output.setImage(newVal)
        updateReliantPips()
    }
    
    // updates output of Image Pip
    func getOutput() -> ImageOutput{
        for item in inputPipIDs{
            let inPip = _mainPipDirectory.getPipByID(item).model
            
            switch inPip.getPipType(){
            case .Text:
                let castItem: TextPip! = inPip as? TextPip
                
                if castItem != nil{
                    let newString = castItem.getOutput().getText() + output.getText()
                    output.setText(newString)
                }
                
            default: // switch pip
                let castItem: SwitchPip! = inPip as? SwitchPip
                if castItem != nil{
                    output.setText("\(castItem.getOutput())")
                }
            }
        }
        return output
    }
}