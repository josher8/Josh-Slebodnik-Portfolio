//
//  PortfolioViewController.swift
//  JosherApp
//
//  Created by Josher Slebodnik on 9/24/15.
//  Copyright © 2015 Josh Slebodnik. All rights reserved.
//

import UIKit
import Parse

class PortfolioViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var parseObjects : [PFObject] = []
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Title
        self.title = "Portfolio"
        activityIndicator.center = view.center
        
        collectionView.hidden = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        dispatch_async(dispatch_get_main_queue(),{
            self.retrieveData()
            dispatch_async(dispatch_get_main_queue(),{

            })
        })
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.parseObjects.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
        
        let object = parseObjects[indexPath.row] as! PFObject
        
        let imageFile = object.objectForKey("thumbnail") as! PFFile
        
        imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
            if error == nil {
                if let image = cell.contentView.viewWithTag(1) as? UIImageView{
                    let imageFile = UIImage(data:imageData!)
                    image.image = imageFile
                    
                }
            }
        }

        
        
        print("Title: ", object.objectForKey("title"))
        
        
        if let title = cell.contentView.viewWithTag(3) as? UILabel{
            title.text = object.objectForKey("title") as? String
        }
        
        
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((collectionView.frame.size.width/3)-2, 100)
    }
    
   func retrieveData(){
        let query = PFQuery(className: "portfolio")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock{(objects, error) -> Void in
            if(error == nil){
                for object in objects!{
                    self.parseObjects.append(object)
                }                
                self.collectionView .reloadData()
                self.collectionView.hidden = false
                self.activityIndicator.stopAnimating()
            }else{
                print(error!.userInfo)
                let noConnection: UILabel = UILabel.init(frame: CGRect(x: 0,y: 70,width: 320,height: 50))
                noConnection.text = "Error retrieving porfolio. Please try again later."
                noConnection.font = UIFont.italicSystemFontOfSize(14)
                noConnection.textColor = UIColor.whiteColor()
                noConnection.textAlignment = NSTextAlignment.Center
                noConnection.baselineAdjustment = UIBaselineAdjustment.AlignBaselines
                noConnection.lineBreakMode = NSLineBreakMode.ByCharWrapping
                noConnection.numberOfLines = 0
                noConnection.clipsToBounds = true
                self.view.addSubview(noConnection);
                self.activityIndicator.stopAnimating()
            }
        
        
        
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            performSegueWithIdentifier("appDetail", sender: cell)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "appDetail"{
            if let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell) {
                    let object = parseObjects[indexPath.row] as PFObject
                    let appDetail: PortfolioDetail = segue.destinationViewController as! PortfolioDetail
                    appDetail.object = object
            }
        }
    }

}