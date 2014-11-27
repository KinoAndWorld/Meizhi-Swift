//
//  Gallary.swift
//  Meizhi-Swift
//
//  Created by kino on 14/11/25.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit
import Alamofire

class Gallary: MeizhiObject {
    var imageUrl:String = ""
    var coverID:String = ""
    class func gallaryWithUrl(imageUrl:String, andCoverID coverID:String) ->Gallary {
        let gallary = Gallary()
        
        gallary.imageUrl = imageUrl
        gallary.coverID = coverID
        return gallary
    }
    
}

class GallaryManager : NSObject {
    
//    public func responseString(completionHandler: (String?, NSError?) -> Void) -> Self {
    class func fetchGallary(completeHandler:(Array<Gallary>) -> Void) -> Void {
        Alamofire.request(.GET, "http://meizhi.im", parameters: nil).responseString {
            (request, response, dataString, error) in
            
            var gallary:[Gallary] = []
            
            if error != nil {
                println(error)
                completeHandler(gallary)
                return
            }
                
//            println(dataString)
            
            let htmlData:NSData? = dataString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) as NSData?
            let xPathParser = TFHpple(HTMLData: htmlData)
            if let element:Array = xPathParser.searchWithXPathQuery("//*[@class='box']/a"){
                for aTagEle in element{
                    
                    let aTagNode:TFHppleElement = aTagEle as TFHppleElement
                    let coversPath = aTagNode.objectForKey("href")
                    
                    if let imageNode = aTagNode.firstChildWithTagName("img"){
                        
                        if let imageUrl = imageNode.objectForKey("src") {
                            gallary.append(Gallary.gallaryWithUrl(imageUrl, andCoverID: coversPath))
                        }
                    }
                    
                    
                }
                println(gallary.count)
                completeHandler(gallary)
            }
        }
//        return gallary
    }
}
