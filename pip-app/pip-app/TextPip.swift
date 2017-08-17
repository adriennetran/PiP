//
//  TextPip.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class TextOutput: BasePipOutput{
//    saves information from past Pips

    // if there aren't data types that combine the two
    var text: String!
    var color: UIColor!
	
	override init(){
		text = ""
		color = UIColor.black
	}
	
	override var description: String {
		return text
	}
	
	// -------------
	//   Accessors
	// -------------
	
	// getText: -> String
	// I/O: returns the text content of the object
	
	func getText() -> String{
		return text
	}
	
	// getColor: -> UIColor
	// I/O: returns the color of the object
	
	func getColor() -> UIColor{
		return color
	}
	
	// ------------
	//   Mutators
	// ------------
	
	// setText: String ->
	// I/O: sets text to newText
	
    func setText(_ newText: String){
        text = newText
    }
	
	// prependText: String ->
	// I/O: appends to the text field
	
	func appendText(_ pText: String){
		text = text + pText
	}
	
	// setColor: UIColor ->
	// I/O: sets color to newColor
	
    func setColor(_ newColor: UIColor){
        color = newColor
    }
}

class TextPip: BasePip {
    
    // of type text
    fileprivate var output: TextOutput!
	
	var baseOutput: String = ""
    
    // TextPip's constructor
	init(id: Int){
		super.init(pipType: PipType.Text, id: id)
    }

    
    func updateText(_ newVal: String){
		baseOutput = newVal
		updateReliantPips()
    }
    
	// getOutput: nil -> TextOutput
	// I/O: updates the output field of the object
	
    func getOutput() -> TextOutput{
		
		output = TextOutput()
        
        for item in inputPipIDs{
			
			let inPip = _mainPipDirectory.getPipByID(item).model
			
            switch inPip.getPipType(){
                
            case .Accel:
                print("accel > text")
                let castItem: AccelPip! = inPip as? AccelPip
                
                let accelView = _mainPipDirectory.getPipByID(castItem.pipID).view
                let accelViewCast: AccelPipView! = accelView as? AccelPipView
                
                if castItem != nil{
                    
//                    output.setAccel(true)
                    
//                     add colorBlock view
//                    accelViewCast.addSubview(accelViewCast.colorBlock)
                    
                    // set text to xyz from accel
                    
//                    output.setText("ACCEL IS INSIDE")
					
                    print("accelViewCast.arrayX")
                    print(accelViewCast.arrayX[0])
					//println(accelViewCast.arrayX[accelViewCast.arrayX.count])
                    print("count")
                    print(accelViewCast.arrayX.count)
                    output.appendText("accel is inside \(accelViewCast.sx)")
                    accelViewCast.photoImageView.layer.addSublayer(accelViewCast.textLayer)

                    
                }else{
                    accelViewCast.textLayer.removeFromSuperlayer()
                }
//                else{
//                    output.setAccel(false)
//                    
//                    // * * * * THIS MAY CAUSE ERRORS
//                    accelViewCast.delete(accelViewCast.colorBlock)
//                    //                    accelViewCast.removeFromSuperview(accelViewCast.colorBlock)
//                }

            case .Text:
				let castItem: TextPip! = inPip as? TextPip
				
				if castItem != nil {
					output.appendText(castItem.getOutput().getText())
				}
				
			case .Color:
				let castItem: ColorPip! = inPip as? ColorPip
				
				if castItem != nil {
					let setColor = castItem.getOutput().color
					output.setColor(setColor!)
				}
			default: // Switch Pip
				let castItem: SwitchPip! = inPip as? SwitchPip
				
				if castItem != nil {
					output.appendText("\(castItem.getOutput())")
				}
            }
            
        }
		
		output.appendText(baseOutput)
        return output
        
    }
}
