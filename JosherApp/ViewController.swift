//
//  ViewController.swift
//  JosherApp
//
//  Created by Josher Slebodnik on 9/24/15.
//  Copyright © 2015 Josh Slebodnik. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private let kTableHeaderHeight: CGFloat = 300
    private let kTableHeaderCutAway: CGFloat = 80.0
    var headerMaskLayer: CAShapeLayer!
    
    var headerView: UIView!
    
    let titles = [
        HomeData(buttonTitle: ""),
        HomeData(buttonTitle: "Portfolio"),
        HomeData(buttonTitle: "Contact Josh"),
        HomeData(buttonTitle: "social")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set Title
        self.title = "Josh Slebodnik"
        //Set Navigation Bar Font
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Futura", size: 20)!]
        
        let effectiveHeight = kTableHeaderHeight-kTableHeaderCutAway/2
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
//
        headerView.layer.mask = headerMaskLayer
        updateHeaderView()
        
        
    }
    override func viewDidAppear(animated: Bool) {
        updateHeaderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableViewDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier : String
        let title = titles[indexPath.row]
        
        if title.buttonTitle.characters.count == 0{
            cellIdentifier = "DescriptionCell"
        }else if title.buttonTitle == "social"{
            cellIdentifier = "SocialCell"
        }else{
            cellIdentifier = "Cell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell

        if let button = cell.contentView.viewWithTag(1) as? UIButton{
            //Set tag to detect which button is pressed when doing buttonSegue
            button.tag = indexPath.row
            button.addTarget(self, action: "buttonSegue:", forControlEvents: UIControlEvents.TouchUpInside)
            button.setTitle(title.buttonTitle, forState: UIControlState.Normal)
        }
        
        if let twitterImage = cell.contentView.viewWithTag(2) as? UIImageView{
            twitterImage.userInteractionEnabled = true
            let twitterTap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: "twitterTap")
            twitterImage.addGestureRecognizer(twitterTap)
        }
        
        if let linkedinImage = cell.contentView.viewWithTag(3) as? UIImageView{
            linkedinImage.userInteractionEnabled = true
            let linkedinTap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: "linkedinTap")
            linkedinImage.addGestureRecognizer(linkedinTap)
        }
        
        return cell
    }
    
    func buttonSegue(sender:UIButton!)
    {
        
        if(sender.tag == 1){
            //Segue to Portfolio if tag is 1
            performSegueWithIdentifier("portfolio", sender: self)
        }else if(sender.tag == 2){
            //Segue to Contact Me if tag is 2
            performSegueWithIdentifier("contact", sender: self)
        }

    }
    
    func twitterTap(){
        let twitterString = "twitter://user?screen_name=josher8"
        let twitterURL = NSURL(string: twitterString)
        if(UIApplication.sharedApplication().canOpenURL(twitterURL!)){
            UIApplication.sharedApplication().openURL(twitterURL!)
        }else{
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.twitter.com/josher8")!)
        }
        
    }
    
    func linkedinTap(){
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.linkedin.com/in/joshslebodnik")!)
        
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row  == 0 {
            return 240
        }else if indexPath.row == 3{
            return 45
        }else{
            return 80
        }
    }
    
    func updateHeaderView(){
        let effectiveHeight = kTableHeaderHeight-kTableHeaderCutAway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + kTableHeaderCutAway/2
        }
        
        headerView.frame = headerRect
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height-kTableHeaderCutAway))
        headerMaskLayer?.path = path.CGPath
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }



}

