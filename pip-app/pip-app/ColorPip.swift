//
//  ColorPip.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/8/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class ColorOutput{
    init(){
        
    }
    var color: UIColor?
}

class ColorPip: BasePip{
    
	init(vc: ViewController, id: Int){
		super.init(vc: vc, pipType: PipType.Color, id: id)
        
    }
    
    func getOutput(){
        
    }
    
}
