//
//  BasicVC.swift
//  ShareSecret
//
//  Created by itsnow on 17/6/1.
//  Copyright © 2017年 fengsong. All rights reserved.
//

import UIKit

class BasicVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        UIView.setAnimationsEnabled(true)
        
//        tabBarController?.tabBar.barTintColor = UIColor.black.withAlphaComponent(0.1)
//        tabBarController?.tabBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
