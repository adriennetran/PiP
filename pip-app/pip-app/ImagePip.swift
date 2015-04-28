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
    var color: UIColor!
    var text: String!
    var switchStatus: Bool!

    
    init(){
        // image initializes as null until user adds something
        text = ""
        color = UIColor.blackColor()
        switchStatus = false
        
    }
    
    func setSwitch(status: Bool){
        switchStatus = status
    }
    
    func getSwitch() -> Bool{
        return switchStatus!
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
                    println("setting text")
                    let newString = castItem.getOutput().getText() + output.getText()
                    println("setting text2")
                    output.setText(newString)
                }
                
            // case .Color
                
            default: // switch pip
                println("switch pip > image pip")
                let castItem: SwitchPip! = inPip as? SwitchPip
                if castItem != nil{
                    if castItem.getOutput() {
                        output.setSwitch(true)
                        
                        // set output image 50% opacity
//                        self.blackLayer.opacity = 0.7
                        
                    }else{
                        output.setSwitch(false)
                        
                        // set output image 100% opacity
//                        self.blackLayer.opacity = 0.2
//                        output.image =
                    }
                }
            }
        }
        return output
    }
}