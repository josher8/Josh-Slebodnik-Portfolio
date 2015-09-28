//
//  PortfolioFullPicture.swift
//  JosherApp
//
//  Created by Josher Slebodnik on 9/26/15.
//  Copyright © 2015 Josh Slebodnik. All rights reserved.
//

import UIKit
import Parse

class PortfolioFullPicture: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var picture: PFFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picture.getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
            if error == nil {
                let imageFile = UIImage(data:imageData!)
                self.imageView.image = imageFile
                
            }
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
