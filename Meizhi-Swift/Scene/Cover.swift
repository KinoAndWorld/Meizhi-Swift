//
//  Cover.swift
//  Meizhi-Swift
//
//  Created by kino on 14/11/25.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit
import Alamofire

class Cover: MeizhiObject {
    var imageUrl:String = ""
    var imageSize:CGSize = CGSizeZero{
        willSet{
            if !CGSizeEqualToSize(newValue, imageSize){
                if (self.obseverImageSize != nil){
                    self.obseverImageSize!(self)
                }
            }
        }
    }
    
    var obseverImageSize:((Cover)->Void)?
    
    
    class func coverWithUrlString(imageUrl:String) ->Cover {
        let cover = Cover()
        
        cover.imageUrl = imageUrl
        return cover
    }
}

class CoverManager: NSObject {
    class func fetchCovers(#coverID:String , andComplete completeHandler:(Array<Cover>) -> Void) -> Void {
        let rootPath = "http://meizhi.im"
        let coversPath:String = "\(rootPath)\(coverID)"
        
        Alamofire.request(.GET, coversPath, parameters: nil).responseString {
            (request, response, dataString, error) in
            var covers:[Cover] = []
            
            if error != nil {
                println(error)
                completeHandler(covers)
                return
            }
            
            //            println(dataString)
            
            let htmlData:NSData? = dataString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) as NSData?
            let xPathParser = TFHpple(HTMLData: htmlData)
            if let element:Array = xPathParser.searchWithXPathQuery("//*[@class='box show-box']/img"){
                for imgEle in element{
                    let imageNode:TFHppleElement = imgEle as TFHppleElement
                    if let imageUrl = imageNode.objectForKey("src") {
                        covers.append(Cover.coverWithUrlString(imageUrl))
                    }
                }
                
                completeHandler(covers)
            }
            
        }
    }

}
