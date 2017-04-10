//
//  Extensions.swift
//  GamesOfChats
//
//  Created by Luiz Alfredo Diniz Hammerli on 08/04/17.
//  Copyright © 2017 Luiz Alfredo Diniz Hammerli. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView{
    
    func loadImageWithUrlString(_ urlString: String)
    {
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString){
        
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: urlString){
            
            URLSession.shared.dataTask(with: url, completionHandler:{(data, response, error) in
                
                if (error != nil){
                    
                    print("erro")
                    return
                }
                
                DispatchQueue.main.async {
                    
                    if let downloadedImage = UIImage(data: data!){
                        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                        self.image = downloadedImage
                    }
                }
            }).resume()
        }
    }
}
