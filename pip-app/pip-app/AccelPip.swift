//
//  ImagePip.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/21/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class AccelOutput{
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

class AccelPip: BasePip{
    
    var output: AccelOutput!
    
    init(id: Int){
        super.init(pipType: PipType.Accel, id: id)
        output = AccelOutput()
    }
    
    func updateImage(newVal: UIImage){
        output.setImage(newVal)
        updateReliantPips()
    }
    
    // updates output of Image Pip
    func getOutput() -> AccelOutput{
        for item in inputPipIDs{
            let inPip = _mainPipDirectory.getPipByID(item).model
            
            switch inPip.getPipType(){
                
            case .Text:
                let castItem: TextPip! = inPip as? TextPip
                
                if castItem != nil{
                    let newString = castItem.getOutput().getText()
                    output.setText(newString)
                }
                
                // case .Color
                
            default: // switch pip
                let castItem: SwitchPip! = inPip as? SwitchPip
                if castItem != nil{
                    if castItem.getOutput() {
                        output.setSwitch(true)
                        // turn on
                        
                    }else{
                        output.setSwitch(false)
                        // turn off
                    }
                }
            }
        }
        return output
    }
}