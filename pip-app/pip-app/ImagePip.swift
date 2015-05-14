//
//  ImagePip.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/21/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class ImageOutput: BasePipOutput{
    var mainImage: UIImage!
    var color: UIColor!
    var text: String!
    var switchStatus: Bool!
    var accelStatus: Bool!

    
    override init(){
        // image initializes as null until user adds something
        text = ""
        color = UIColor.blackColor()
        switchStatus = false
        accelStatus = false
        mainImage = nil
        
    }
	
	override var description: String {
		return "ImageOutput: \n with Text: \(text)"
	}
    
    func setAccel(status: Bool){
        accelStatus = status
    }
    
    func getAccel() -> Bool{
        return accelStatus!
    }
    
    func setSwitch(status: Bool){
        switchStatus = status
    }
    
    func getSwitch() -> Bool{
        return switchStatus!
    }
    
    func getImage() -> UIImage{
        println("Inside ImagePip.swift -> getImage()")
        if let img = mainImage{
            println("ImageOutput: getImage() actually has something")
            return img
        }
        println("ImageOutput: getImage() has nothing")
        return UIImage()
    }
    
    func setImage(newImage: UIImage){
        mainImage = newImage
    }
    
    func getText() -> String{
        return text
    }
    
    func setText(newText: String) -> String{
        text = newText
        return text
    }
    
    // getColor: -> UIColor
    // I/O: returns the color of the object
    
    func getColor() -> UIColor{
        return color
    }

    // setColor: UIColor ->
    // I/O: sets color to newColor
    
    func setColor(newColor: UIColor){
        color = newColor
    }

}

class ImagePip: BasePip{
    
    var output: ImageOutput!
    
    init(id: Int){
        super.init(pipType: PipType.Accel, id: id)
        output = ImageOutput()
    }
    
    override func pipToBeDestroyed() {
        super.pipToBeDestroyed()

        var curView = _mainPipDirectory.getPipByID(self.pipID).view as? ImagePipView
        curView!.photoImageView.removeFromSuperview()
        curView!.textView.removeFromSuperview()
        
        println("deleting image pip!")
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
                
            case .Image:
                let castItem: ImagePip! = inPip as? ImagePip
                let castItemView = _mainPipDirectory.getPipByID(castItem.pipID).view as? ImagePipView
                if castItem != nil{
                    println("changing alpha of new image")
                    castItemView!.photoImageView.alpha = 0.7
                }
                
            case .Accel:
                let castItem: AccelPip! = inPip as? AccelPip
                
                if castItem != nil{
                    println( "accel > image. accel is not nil")
                    output.setAccel(true)
                    }else{
                    println( "accel > image. accel is nil")
                        output.setAccel(false)
                    }
                
            case .Color:
                let castItem: ColorPip! = inPip as? ColorPip
                
                if castItem != nil {
                    let setColor = castItem.getOutput().color
                    output.setColor(setColor)
                }
                
            case .Text:
                let castItem: TextPip! = inPip as? TextPip
                
                if castItem != nil{
                    println("setting text")
                    let newString = castItem.getOutput().getText()
                    println("setting text2")
                    output.setText(newString)
                    println("the text should be")
                    println(newString)
                }
                
            // case .Color
                
            default: // switch pip
                println("switch pip > image pip")
                let castItem: SwitchPip! = inPip as? SwitchPip
                if castItem != nil{
                    if castItem.getOutput().getState() {
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