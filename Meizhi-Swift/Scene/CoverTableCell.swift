//
//  CoverTableCell.swift
//  Meizhi-Swift
//
//  Created by kino on 14/11/27.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit

class CoverTableCell: UITableViewCell {
//    var cardContainer:CALayer?
//    var coverImageView:ASImageNode?
//    var toolBarNode:ASDisplayNode?
    var model:Cover?
    
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardContainer.layer.borderWidth = 2
        cardContainer.layer.borderColor = UIColor.whiteColor().CGColor
//        cardContainer.layer.shadowColor = UIColor.grayColor().CGColor
//        cardContainer.layer.shadowOpacity = 0.3
//        cardContainer.layer.shadowRadius = 10
        //
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        cardContainer?.frame = CGRect(x: 10, y: 10, width: contentView.frame.size.width - 20, height: contentView.frame.size.height - 10)
//        
//        coverImageView?.frame = CGRect(x: 0, y: 50, width: cardContainer!.frame.size.width, height: cardContainer!.frame.size.height - 50)
//        
//    }
    
    
    //MARK: Config Cell
    func configureCellWithCover(model:Cover){
        self.model = model
        coverImageView.sd_setImageWithURL(NSURL(string: model.imageUrl),
            placeholderImage: UIImage(named: "cardPlaceholder"),
            options: SDWebImageOptions.ContinueInBackground ,
            progress: { (receivedSize, expectiveSize) -> Void in
                println("下载进度\(receivedSize)/\(expectiveSize)")
                //progressView.setProgress(CGFloat(receivedSize/expectiveSize), animated: true)
            },completed: { [weak self /*, weak progressView*/]
                (resultImage, error, cacheType, url) -> Void in
                if let strongSelf = self {
                    if (resultImage != nil){
                        strongSelf.coverImageView.image = resultImage
                        strongSelf.model?.imageSize = CGSize(width: resultImage.size.width/2, height: resultImage.size.height/2)
                    }
                }
        })
    }
    
    
}
