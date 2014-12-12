//
//  BaseController.swift
//  Meizhi-Swift
//
//  Created by kino on 14/11/25.
//  Copyright (c) 2014年 kino. All rights reserved.
//

import UIKit

class BaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
//        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func instanceControllerByName(storyID:String)->UIViewController?{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyID) as UIViewController?
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
