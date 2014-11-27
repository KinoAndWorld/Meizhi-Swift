//
//  CoverController.swift
//  Meizhi-Swift
//
//  Created by kino on 14/11/26.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit

extension Array {
    func find(includedElement: T -> Bool) -> Int? {
        for (idx, element) in enumerate(self) {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
}

class CoverController: BaseController , UITableViewDelegate , UITableViewDataSource{
    
    var coverID = ""
    var covers:Array<Cover> = []
    
    @IBOutlet weak var coverTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
    }
    
    func prepareData(){
        if coverID != ""{
            CoverManager.fetchCovers(coverID: coverID, andComplete:{
                [weak self] covers in
                if let strongSelf = self{
                    strongSelf.covers = covers
                    strongSelf.observerCoverSize()
                    strongSelf.reloadCoversData()
                }
            })
        }
    }
    
    func observerCoverSize(){
        for cover in covers{
            cover.obseverImageSize = {
                [weak self] newSizeCover in
                if let sgSelf = self{
                    let index = sgSelf.covers.find{ $0 == newSizeCover}
                    if index != nil {
                        sgSelf.reloadTableByRow(index!)
                    }
                }
            }
        }
    }
    
    func reloadTableByRow(row:Int){
        
        dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            if let sgSelf = self{
                sgSelf.coverTableView.beginUpdates()
                sgSelf.coverTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                sgSelf.coverTableView.endUpdates()
            }
        })
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightForIndexPath(indexPath)
    }
    
    func heightForIndexPath(indexPath:NSIndexPath) -> CGFloat{
        let model = self.covers[indexPath.row] as Cover
        if model.imageSize.height != 0 {
            return model.imageSize.height
        }else{
            return 500
        }
    }
    
    func reloadCoversData(){
        coverTableView.reloadData()
    }
    
    //MARK: TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.covers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let coverCell = tableView.dequeueReusableCellWithIdentifier("CoverTableCell", forIndexPath: indexPath) as CoverTableCell
        
        let model = self.covers[indexPath.row] as Cover
        coverCell.configureCellWithCover(model)
        
        return coverCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let model = self.covers[indexPath.row] as Cover
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as CoverTableCell
        
        let imageInfo = JTSImageInfo()
        imageInfo.image = cell.coverImageView.image
        imageInfo.imageURL = NSURL(string:  model.imageUrl)
        imageInfo.referenceRect = cell.coverImageView.frame;
        imageInfo.referenceView = cell.coverImageView.superview;
        
        
        let imageViewer = JTSImageViewController(imageInfo: imageInfo,
            mode: JTSImageViewControllerMode.Image,
            backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
        
        imageViewer.showFromViewController(self,
            transition: JTSImageViewControllerTransition._FromOriginalPosition)
        
    }
    
    //MARK: Will Delete
    func swipeView(swipeView: SwipeView!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        let imageView = UIImageView(frame: swipeView.bounds)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
//        let progressView = M13ProgressViewRing(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
//        progressView.center = imageView.center
//        progressView.showPercentage = true
//        progressView.primaryColor = UIColor.orangeColor()
//        progressView.secondaryColor = UIColor.whiteColor()
//        imageView.addSubview(progressView)
        
        let coverModel = self.covers[index] as Cover
        if let imageUrl = NSURL(string: coverModel.imageUrl){
            imageView.sd_setImageWithURL(imageUrl,
                placeholderImage: UIImage(named: "cardPlaceholder"),
                options: SDWebImageOptions.ContinueInBackground ,
                progress: { (receivedSize, expectiveSize) -> Void in
                    println("下载进度\(receivedSize)/\(expectiveSize)")
//                    progressView.setProgress(CGFloat(receivedSize/expectiveSize), animated: true)
                },completed: { [weak imageView /*, weak progressView*/]
                    (resultImage, error, cacheType, url) -> Void in
                    if let strongImageView = imageView {
                        strongImageView.image = resultImage
//                        if let strongProgress = progressView{
//                            strongProgress.removeFromSuperview()
//                        }
                    }
                })
        }
        
        return imageView
    }
    
    
    
    
}
