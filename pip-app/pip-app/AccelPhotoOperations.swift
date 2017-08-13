//
//  AccelPhotoOperations.swift
//  pip-app
//
//  Created by Adrienne Tran on 4/30/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation
import UIKit

class PendingOperations{
    
    lazy var filtrationInProgress = [IndexPath:OperationQueue]()
    lazy var filtrationQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Filtration Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
}
