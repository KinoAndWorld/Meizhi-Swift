//
//  GallaryViewLayout.swift
//  Meizhi-Swift
//
//  Created by kino on 14/11/26.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit

class GallaryViewLayout: UICollectionViewLayout {
    let kGallaryLayoutCellKind = "GallaryCell"
    
    var itemInsets:UIEdgeInsets = UIEdgeInsetsZero
    var itemSize:CGSize = CGSizeZero
    
    var interItemSpacingY:CGFloat = 0.0
    var numberOfColumns:Int = 1
    
    private var layoutInfo = NSDictionary()
    
    //MARK: Function
    override init() {
        super.init()
        
        initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    func initialize(){
        
        let mainWidth = UIApplication.sharedApplication().keyWindow?.bounds.width
        
        
        self.itemSize = CGSize(width: 150, height: 150)
        self.itemInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.interItemSpacingY = 12.0
        self.numberOfColumns = 2
    }
    
    override func prepareLayout() {
        var newLayoutInfo = NSMutableDictionary()
        var cellLayoutInfo = NSMutableDictionary()
        
        let sectionCount = self.collectionView?.numberOfSections()
        var indexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        for (var section = 0 ; section < sectionCount ; section++){
            let itemCount = self.collectionView?.numberOfItemsInSection(section)
            for (var item = 0; item < itemCount ; item++){
                indexPath = NSIndexPath(forRow: item, inSection: section)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                
                itemAttributes.frame = self.frameForAlbumPhotoAtIndexPath(indexPath)
                cellLayoutInfo[indexPath] = itemAttributes
            }
        }
        
        newLayoutInfo[kGallaryLayoutCellKind] = cellLayoutInfo
        self.layoutInfo = newLayoutInfo
        
    }
    
    //MARK: 计算布局
    func frameForAlbumPhotoAtIndexPath(indexPath:NSIndexPath) -> CGRect{
        //行数和列数
        let row = indexPath.section / self.numberOfColumns
        let column = indexPath.row / self.numberOfColumns
        
        var spacingX:CGFloat =
                CGFloat(self.collectionView!.bounds.width) -
                    CGFloat(self.itemInsets.left) -
                CGFloat(self.itemInsets.right) -
                (CGFloat(self.numberOfColumns) * CGFloat(self.itemSize.width))
        
        
        
        return CGRectZero
    }
    
    
    
}
