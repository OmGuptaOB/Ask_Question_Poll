//
//  TabBarViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 25/03/26.
//

import UIKit

class TabBarViewController: UIViewController {

//    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tabBar: UIView!
    @IBOutlet weak var containerview: UIView!
    
    @IBOutlet weak var tabitem1: UIView!
    @IBOutlet weak var tabitem2: UIView!
    @IBOutlet weak var tabitem3: UIView!
    @IBOutlet weak var tabitem4: UIView!
    
    @IBOutlet weak var tabItemButton1: UIButton!
    @IBOutlet weak var tabItemButton2: UIButton!
    @IBOutlet weak var tabItemButton3: UIButton!
    @IBOutlet weak var tabItemButton4: UIButton!
    
    
    var currentVC: UIViewController?
    lazy var homeVC       = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
        setupButtons()
    }
    func setupTabbar() {
        selectTab(at: 0)
//        switchVc(homeVC)
    }
    
    func setupButtons() {
        tabItemButton1.tag = 0
        tabItemButton2.tag = 1
        tabItemButton3.tag = 2
        tabItemButton4.tag = 3
        
        [tabItemButton1, tabItemButton2, tabItemButton3, tabItemButton4].forEach {
            $0?.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc func tabTapped(_ sender: UIButton) {
        selectTab(at: sender.tag)
    }
    
    func selectTab(at index: Int) {
        //Update background colors
        let tabItems = [tabitem1, tabitem2, tabitem3, tabitem4]
        tabItems.enumerated().forEach { i, item in
            item?.backgroundColor = i == index ? .white : .clear
        }
        // Switch VC
        switch index {
        case 0: switchVC(homeVC)
        default: break
        }
    }

    func switchVC(_ vc: UIViewController) {
        
        guard vc != currentVC else { return }
        
        if let current = currentVC {
            current.willMove(toParent: nil)
            current.view.removeFromSuperview()
            current.removeFromParent()
        }
        
        addChild(vc)
        vc.view.frame = containerview.bounds
        containerview.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        currentVC = vc
    }
}

