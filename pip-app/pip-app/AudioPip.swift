//
//  ImagePip.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/21/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class AudioOutput: BasePipOutput{
    var image: UIImage!
    var color: UIColor!
    var text: String!
    var switchStatus: Bool!
    var accelStatus: Bool!
    
    
    override init(){
        // image initializes as null until user adds something
        text = ""
        color = UIColor.black
        switchStatus = false
        accelStatus = false
        image = nil
        
    }
    
    override var description: String {
        return "ImageOutput: \n with Text: \(text)"
    }
    
    func setAccel(_ status: Bool){
        accelStatus = status
    }
    
    func getAccel() -> Bool{
        return accelStatus!
    }
    
    func setSwitch(_ status: Bool){
        switchStatus = status
    }
    
    func getSwitch() -> Bool{
        return switchStatus!
    }
    
    func getImage() -> UIImage{
        return image
    }
    
    func setImage(_ newImage: UIImage){
        image = newImage
    }
    
    func getText() -> String{
        return text
    }
    
    func setText(_ newText: String) -> String{
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
    
    func setColor(_ newColor: UIColor){
        color = newColor
    }
    
}

class AudioPip: BasePip{
    
    var output: AudioOutput!
    
    init(id: Int){
        super.init(pipType: PipType.Accel, id: id)
        output = AudioOutput()
    }
    
    override func pipToBeDestroyed() {
        super.pipToBeDestroyed()
        
//        var curView = _mainPipDirectory.getPipByID(self.pipID).view as? AudioPipView
//        curView!.photoImageView.removeFromSuperview()
//        curView!.textView.removeFromSuperview()
        
        print("deleting audio pip!")
    }
    
    func updateImage(_ newVal: UIImage){
        output.setImage(newVal)
        updateReliantPips()
    }
    
    // updates output of Image Pip
    func getOutput() -> AudioOutput{
        for item in inputPipIDs{
            let inPip = _mainPipDirectory.getPipByID(item).model
            
            switch inPip.getPipType(){
                
            case .Image:
                let castItem: ImagePip! = inPip as? ImagePip
//                let castItemView = _mainPipDirectory.getPipByID(castItem.pipID).view as? ImagePipView
                
            case .Accel:
                let castItem: AccelPip! = inPip as? AccelPip
                
                if castItem != nil{
                    output.setAccel(true)
                }else{
                    output.setAccel(false)
                }
                
            case .Color:
                let castItem: ColorPip! = inPip as? ColorPip
                
                if castItem != nil {
                    let setColor = castItem.getOutput().color
                    output.setColor(setColor!)
                }
                
            case .Text:
                let castItem: TextPip! = inPip as? TextPip
                
                if castItem != nil{
                    print("setting text")
                    let newString = castItem.getOutput().getText()
                    print("setting text2")
                    output.setText(newString)
                    print("the text should be")
                    print(newString)
                }
                
                // case .Color
                
            default: // switch pip
                print("switch pip > image pip")
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
