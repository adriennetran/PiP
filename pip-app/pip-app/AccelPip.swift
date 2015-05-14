//
//  ImagePip.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/21/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit


class AccelOutput: BasePipOutput{
    var image: UIImage!
    var color: UIColor!
    var text: String!
    var switchStatus: Bool!
    
    
    override init(){
        // image initializes as null until user adds something
        text = ""
        color = UIColor.blackColor()
        switchStatus = false
        
    }
	
	override var description: String {
		return "AccelOutput"
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
    
    // setColor: UIColor ->
    // I/O: sets color to newColor
    
    func setColor(newColor: UIColor){
        color = newColor
    }
    
    func getColor() -> UIColor{
        return color
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
		
		// ----------------------------------
		//	I thought we decided that the accelerometer pip shouldnt take any inputs. 
		//	The way this function is being used in the block comment below is wrong.
		//	It is finding the pips that should be inputs to this pip, and changing their outputs.
		//	Its not a two way stream. They should only affect THIS pip.
		// ----------------------------------
		
        /*for item in inputPipIDs{
            let inPip = _mainPipDirectory.getPipByID(item).model
            
            switch inPip.getPipType(){
                
            case .Text:
                
				if let castItem = inPip as? TextPip{
                    let newString = castItem.getOutput().getText()
                    output.setText(newString)
                }
                
            case .Color:
				
                if let castItem = inPip as? ColorPip {
                    let setColor = castItem.getOutput().color
                    output.setColor(setColor)
                }
                
            default: // switch pip
                if let castItem = inPip as? SwitchPip{
                    if castItem.getOutput() {
                        output.setSwitch(true)
                        // turn on
                        
                    }else{
                        output.setSwitch(false)
                        // turn off
                    }
                }
            }
        }*/
        return output
    }
}