//
//  GallaryController.swift
//  Meizhi-Swift
//
//  Created by kino on 14/11/25.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit

class GallaryController: BaseController , UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var gallaryCollectionView: UICollectionView!
    
    
    var gallery:[Gallary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        gallaryCollectionView.registerClass(GallaryCell.self, forCellWithReuseIdentifier: "GallaryCell")
        
        GallaryManager.fetchGallary {
            [weak self] searchGallary in
            if let strongSelf = self{
                strongSelf.gallery = searchGallary
                strongSelf.reloadGallaryData()
            }
        }
    }
    
    private func reloadGallaryData(){
        for gal:Gallary in gallery{
            println(gal.imageUrl)
        }
        
        gallaryCollectionView.reloadData()
        
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

    // MARK: - Collection
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.gallery.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GallaryCell",
            forIndexPath: indexPath) as GallaryCell
        let model = self.gallery[indexPath.row]
        cell.configureCellWithModel(model)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = CGFloat(floor(UIApplication.sharedApplication().keyWindow!.bounds.width) / 2.0) - 2
        let realSize = CGSize(width: width, height: width)
        return realSize
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 1, 1, 1)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("select section:\(indexPath.section) andRow: \(indexPath.row)")
        let gallaryModel = gallery[indexPath.row]
        if let dest = self.instanceControllerByName("CoverController") as? CoverController{
            dest.coverID = gallaryModel.coverID
            self.navigationController?.pushViewController(dest, animated: true)
        }
    }
}
