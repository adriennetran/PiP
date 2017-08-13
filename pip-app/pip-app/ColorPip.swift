//
//  ColorPip.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/8/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class ColorOutput: BasePipOutput{
	
	var color: UIColor!
    var accelStatus: Bool!
	
    override init(){
        color = UIColor.black
        accelStatus = false
    }
	
	override var description: String {
		return color.description
	}
    
    func setAccel(_ status: Bool){
        accelStatus = status
    }
    
    func getAccel() -> Bool{
        return accelStatus!
    }
    
    func getColor() -> UIColor{
        return color
    }
    
    func setColor(_ newColor: UIColor){
        color = newColor
    }
}

class ColorPip: BasePip{
	
	var output: ColorOutput!
	
	var colorDirectory: [String: UIColor] =
	["red":UIColor.red,
	"blue":UIColor.blue,
	"green": UIColor.green,
	"purple": UIColor.purple,
	"orange": UIColor.orange,
	"yellow": UIColor.yellow,
	]
	
	init(id: Int){
		super.init(pipType: PipType.Color, id: id)
		
		output = ColorOutput()
		
    }
    
    func updateColor(_ newVal: UIColor){
        output.setColor(newVal)
		updateReliantPips()
    }
    
    // getOutput loops through the array of inputPips and processes each, storing the information in output
    
    // Input: Array of input pips
    
    func getOutput() -> ColorOutput{
        // format
        
        // Takes in the last input
        // color -> text
        // Output is always of same type of Pip
        
        for item in inputPipIDs{
			
			let inPip = _mainPipDirectory.getPipByID(item).model
            
            switch inPip.getPipType(){
                
            case .Accel:
                let castItem: AccelPip! = inPip as? AccelPip
                
                var accelView = _mainPipDirectory.getPipByID(castItem.pipID).view
                var accelViewCast: AccelPipView! = accelView as? AccelPipView
                
                if castItem != nil{
                    
                    output.setAccel(true)
                    
                    // add colorBlock view
                    accelViewCast.addSubview(accelViewCast.colorBlock)
                    print("arrayX")
                    var x = accelViewCast.arrayX[accelViewCast.arrayX.count-1]
                    var y = accelViewCast.arrayY[accelViewCast.arrayY.count-1]
                    var z = accelViewCast.arrayZ[accelViewCast.arrayZ.count-1]
                    
                    var myColor = UIColor(red: z*2.0, green: x*2.0, blue: y*2.0, alpha: 1.0)
                    
                    output.setColor(myColor)
                    
                }else{
                    output.setAccel(false)
                    
                    // * * * * THIS MAY CAUSE ERRORS
                    accelViewCast.delete(accelViewCast.colorBlock)
//                    accelViewCast.removeFromSuperview(accelViewCast.colorBlock)
                }
                
                
            case .Text:
				let castItem: TextPip! = inPip as? TextPip
				
				if castItem != nil{
					
					if let unwrappedValue = colorDirectory[castItem.getOutput().getText().lowercased()]{
						output.color = unwrappedValue
					}else{
						output.color = UIColor.black
					}
				}
                return output
                
            case .Color:
                let castItem: ColorPip! = inPip as? ColorPip
                
                if castItem != nil{
					var h1:CGFloat = 0; var s1:CGFloat=0; var b1:CGFloat = 0; var a1:CGFloat = 0;
					var h2:CGFloat = 0; var s2:CGFloat=0; var b2:CGFloat = 0; var a2:CGFloat = 0;
					
					output.color.getHue(&h1, saturation: &s1, brightness: &b1, alpha: &a1)
					castItem.getOutput().getColor().getHue(&h2, saturation: &s2, brightness: &b2, alpha: &a2)
					
                    output.color = UIColor(hue: (h1 * h2)/2, saturation: (s1*s2)/2, brightness: (b1*b2)/2, alpha: (a1*a2)/2)
                }
                
			default:	//Switch Pip case
				let castItem: SwitchPip! = inPip as? SwitchPip
				
				if castItem != nil{
					if castItem.getOutput().getState() {
						output.color = UIColor.white
					}else{
						output.color = UIColor.black
					}
				}
            }
            
        }
		
        return output
        
    }
    
}
