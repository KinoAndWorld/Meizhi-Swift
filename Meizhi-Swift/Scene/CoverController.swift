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
    
    var loadingView:LoadingView? = nil
    
    @IBOutlet weak var coverTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
    }
    
    func prepareData(){
        loadingView = LoadingView()
        loadingView!.showMe()
        if coverID != ""{
            CoverManager.fetchCovers(coverID: coverID, andComplete:{
                [weak self] covers in
                
                if let strongSelf = self{
                    strongSelf.loadingView?.hideMe()
                    if covers.count != 0{
                        strongSelf.covers = covers
                        strongSelf.observerCoverSize()
                        strongSelf.reloadCoversData()
                    }else{
                        //handle blank data
                        
                    }
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
        coverCell.touchCellCall = {[weak self] covCell in
            if let sSelf = self{
                let model = covCell.model! as Cover
                
                let imageInfo = JTSImageInfo()
                imageInfo.image = covCell.coverImageView.image
                imageInfo.imageURL = NSURL(string:  model.imageUrl)
                imageInfo.referenceRect = covCell.coverImageView.frame;
                imageInfo.referenceView = covCell.coverImageView.superview;
                
                let imageViewer = JTSImageViewController(imageInfo: imageInfo,
                    mode: JTSImageViewControllerMode.Image,
                    backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
                
                imageViewer.showFromViewController(self,
                    transition: JTSImageViewControllerTransition._FromOriginalPosition)
            }
        }
        
        return coverCell
    }
}
