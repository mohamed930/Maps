//
//  UIImage.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import UIKit

extension UIImage {
    
    func imageWithSize(scaledToSize newSize: CGSize) -> UIImage {
       UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
       self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
       let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
       UIGraphicsEndImageContext()
       return newImage
   }
    
}
