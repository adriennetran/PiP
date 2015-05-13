//
//  Utils.swift
//  pip-app
//
//  Created by Peter Slattery on 5/11/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

// distance: CGPoint, CGPoint -> Float
// I/O: returns a float representing the distance between a and b

func distance(a: CGPoint, b: CGPoint) -> Float {
	let dx: Float = Float(a.x - b.x)
	let dy: Float = Float(a.y - b.y)
	let d: Float = (dx*dx) + (dy*dy)
	return sqrt(d)
}


// length: CGPoint -> Float
// I/O: returns a float representing the lenght of a, where a is a vector2
func length(a: CGPoint) -> Float{
	let x: Float = Float(a.x * a.x)
	let y: Float = Float(a.y * a.y)
	let d: Float = x + y
	return sqrt(d)
}

func normalize(a: CGPoint) -> CGPoint {
	let l = length(a)
	return CGPoint(x: a.x / CGFloat(l), y: a.y / CGFloat(l))
}