//
//  GallaryCell.swift
//  Meizhi-Swift
//
//  Created by kino on 14/11/26.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit



class GallaryCell: UICollectionViewCell {
    
    @IBOutlet weak var gallaryImage: UIImageView!
    
    override func awakeFromNib() {
        println(gallaryImage.frame.height)
        
        println("ok")
    }
    
    func configureCellWithModel(model:Gallary){
        if let imageUrl = NSURL(string: model.imageUrl){
            gallaryImage.sd_setImageWithURL(imageUrl,
                placeholderImage: UIImage(named: "cardPlaceholder")) {
                    [weak self] (image, error, cacheType, resultUrl) -> Void in
                    if let strongSelf = self{
                        strongSelf.gallaryImage.image = image
                    }
            }
        }else{
            gallaryImage.image = UIImage(named: "cardPlaceholder")
        }
    }
}
