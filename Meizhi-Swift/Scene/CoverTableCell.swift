//
//  CoverTableCell.swift
//  Meizhi-Swift
//
//  Created by kino on 14/11/27.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit

typealias whenTouchCell = (CoverTableCell)->Void

class CoverTableCell: UITableViewCell {
    
    var model:Cover?
    
    var isActive:Bool = false
    
    var touchCellCall:whenTouchCell?
    
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardContainer.layer.borderWidth = 2
        cardContainer.layer.borderColor = UIColor.whiteColor().CGColor
        
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        cardContainer?.frame = CGRect(x: 10, y: 10, width: contentView.frame.size.width - 20, height: contentView.frame.size.height - 10)
//        
//        coverImageView?.frame = CGRect(x: 0, y: 50, width: cardContainer!.frame.size.width, height: cardContainer!.frame.size.height - 50)
//        
//    }
    override func prepareForReuse() {
        var progressView = cardContainer.viewWithTag(1024) as M13ProgressViewBar?
        progressView?.removeFromSuperview()
        self.isActive = false
        super.prepareForReuse()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch: UITouch  = touches.anyObject() as UITouch
        let point = touch.locationInView(self.cardContainer)
        if CGRectContainsPoint(self.cardContainer.bounds, point){
            touchCellCall?(self)
        }
    }
    
    func imageDownloadProgress(notif: NSNotification){
        if let dic = notif.object as NSDictionary?{
            var receivedSize = dic["receivedSize"]?.floatValue
            var expectiveSize = dic["expectedSize"]?.floatValue
            if (receivedSize == nil || expectiveSize == nil) {
                receivedSize = 0.0
                expectiveSize = -1.0
                return;
            }
            
            if abs(receivedSize!/expectiveSize!) == 0 {
                return;
            }
            
            let url = dic["url"] as NSURL?
            println("url is : \(url), and modelUrl: \(model!.imageUrl)")
            
            if (url != nil && model?.imageUrl != nil){
                if url!.absoluteString == model!.imageUrl {
//                    println("OKOKOKOK!!!!!")
                    var progressView = self.cardContainer.viewWithTag(1024) as M13ProgressViewBar?
                    if (NSThread.isMainThread()) {
                        progressView?.setProgress(CGFloat(receivedSize!/expectiveSize!), animated: true)
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            println("load")
                            progressView?.setProgress(CGFloat(receivedSize!/expectiveSize!), animated: true)
                        })
                    }
                }
            }
            
            
        }
    }
    
    //MARK: Config Cell
    func configureCellWithCover(model:Cover){
        self.model = model
        self.isActive = true
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"imageDownloadProgress:",
            name: SDWebImageDownloadProgressNotification,
            object: nil)
        
        var progressView: M13ProgressViewBar = M13ProgressViewBar()
        progressView.percentagePosition = M13ProgressViewBarPercentagePositionTop
        progressView.frame = CGRectMake(0,CGRectGetMaxY(cardContainer.bounds)-50, cardContainer.bounds.width, 50)
        progressView.hidden = false
        progressView.tag = 1024
        progressView.setProgress(0, animated: true)
        cardContainer.addSubview(progressView)
        
//        SDWebImageDownloader
//        SDWebImageManagerDelegate
//        SDWebImageManager.sharedManager().downloadImageWithURL(model.imageUrl,
//            options: SDWebImageOptions.ContinueInBackground,
//            progress: { (receivedSize, expectiveSize) -> Void in
//                
//        }) { (resultImage, error, cacheType, finish, url) -> Void in
//            
//        }
        
        coverImageView.sd_setImageWithURL(NSURL(string: model.imageUrl),
            placeholderImage: UIImage(named: "cardPlaceholder"),
            options: SDWebImageOptions.ContinueInBackground ,
            progress: { [weak self] (receivedSize, expectiveSize) -> Void in
                if let strgSelf = self {
                    if strgSelf.isActive {
                    }
                }
                println("下载进度\(receivedSize)/\(expectiveSize)")
                
            },completed: { [weak self /*, weak progressView*/]
                (resultImage, error, cacheType, url) -> Void in
                if let strongSelf = self {
                    if !strongSelf.isActive {
                        return
                    }
                    var progressView = strongSelf.cardContainer.viewWithTag(1024) as M13ProgressViewBar?
                    progressView?.hidden = true
                    
                    if error != nil{
                        let alert = UIAlertView(title: "image load failed",
                            message: error?.description ,
                            delegate: nil,
                            cancelButtonTitle: nil)
                        return
                    }
                    if (resultImage != nil){
                        strongSelf.coverImageView.image = resultImage
                        strongSelf.model?.imageSize = CGSize(width: resultImage.size.width/2, height: resultImage.size.height/2)
                    }
                }
        })
    }
}
