//
//  PortfolioDetail.swift
//  JosherApp
//
//  Created by Josher Slebodnik on 9/26/15.
//  Copyright © 2015 Josh Slebodnik. All rights reserved.
//

import UIKit
import Parse

class PortfolioDetail: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    var object: PFObject!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    var imageFiles:[PFFile] = []
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Title
        self.title = object!.objectForKey("title") as? String
        let appButton : UIBarButtonItem = UIBarButtonItem(title: "App Store", style: UIBarButtonItemStyle.Plain, target: self, action: "appLink")
        self.navigationItem.rightBarButtonItem = appButton
        
        imageFiles.append((object!.objectForKey("image1") as? PFFile)!)
        imageFiles.append((object!.objectForKey("image2") as? PFFile)!)
        imageFiles.append((object!.objectForKey("image3") as? PFFile)!)
        descriptionLabel.text = object!.objectForKey("description") as? String
        
        setupCollectionView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupCollectionView(){
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        collectionView.pagingEnabled = true
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        collectionView.layoutIfNeeded()
        
        collectionView.reloadData()
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageFiles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
        
        
        if let image = cell.contentView.viewWithTag(1) as? UIImageView{
            let imageObject = imageFiles[indexPath.row] as! PFFile
            
            imageObject.getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
                if error == nil {
                    let imageFile = UIImage(data:imageData!)
                    image.image = imageFile
                    image.hidden = false
                }
            }
        }
        
        
        return cell
    }
    

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.view.frame.size
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        
        let visibleRect: CGRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint: CGPoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect))
        let visibleIndexPath: NSIndexPath = collectionView.indexPathForItemAtPoint(visiblePoint)!
        pageControl.currentPage = visibleIndexPath.row
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            performSegueWithIdentifier("fullPicture", sender: cell)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fullPicture"{
            if let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell) {
                let imageObject = imageFiles[indexPath.row] as! PFFile
                let pictureDetail: PortfolioFullPicture = segue.destinationViewController as! PortfolioFullPicture
                pictureDetail.picture = imageObject
            }
        }
    }
    
    
    func appLink(){
        print(NSURL(string:(object!.objectForKey("link") as? String)!)!)
        UIApplication.sharedApplication().openURL(NSURL(string:(object!.objectForKey("link") as? String)!)!)
        
        
    }

    
}
