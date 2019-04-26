//
//  BasicNav.swift
//  ShareSecret
//
//  Created by itsnow on 17/6/1.
//  Copyright © 2017年 fengsong. All rights reserved.
//

import UIKit

class BasicNav: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.1)
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let attributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),NSAttributedString.Key.foregroundColor:UIColor.orange]
        navigationBar.titleTextAttributes = attributes
        navigationBar.isTranslucent = false
        
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
        
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

extension BasicNav : UIGestureRecognizerDelegate,UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        self.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //在push或pop动画的过程中，禁用默认的手势
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        
        if  animated  {
            //self.interactivePopGestureRecognizer?.isEnabled = false
        }
        return super.popToRootViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if animated == true {
            //self.interactivePopGestureRecognizer?.isEnabled = false
        }
        return super.popToViewController(viewController, animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if  animated == true {
            //self.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        super.pushViewController(viewController, animated: animated)
        
        let count = self.viewControllers.count
        let leftBarIten = viewController.navigationItem.leftBarButtonItem
        
        if leftBarIten == nil && count > 1{
            viewController.hidesBottomBarWhenPushed = true
            
            //viewController.navigationItem.setLeftBarButton(createBackButton(), animated: true)
            //viewController.navigationItem.backBarButtonItem = createBackButton()
        }
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        
        return super.popViewController(animated: animated)
    }
        
    @objc func popself(){

        //self.popViewController(animated: true)
    }
    
    func createBackButton() -> UIBarButtonItem{
        let backBtn = createButtonWithImage(normalImage: "title_back", clickIamge: "", target: self, selector: #selector(BasicNav.popself))
        let barItem = UIBarButtonItem(customView: backBtn)
        return barItem
    }
    
    func createButtonWithImage(normalImage:String,clickIamge:String,target:AnyObject,selector:Selector) -> UIButton
    {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.clear
        button.frame = CGRect.init(x: 5, y: 5, width: 34, height: 34)
        if(!normalImage.isEmpty){
            button.setBackgroundImage(UIImage(named: normalImage), for: .normal)
        }
        if(!clickIamge.isEmpty){
            button.setBackgroundImage(UIImage(named: clickIamge), for: .highlighted)
        }
        button.addTarget(target, action: selector, for: .touchUpInside)
        
        return button
    }
}
