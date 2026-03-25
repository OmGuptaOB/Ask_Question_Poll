//
//  TabBarViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 25/03/26.
//

import UIKit

class TabBarViewController: UIViewController {

    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var containerview: UIView!
    
    var currentVC: UIViewController?
    
    var homeVC: HomeViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabbar()
    }
    
    func setupTabbar() {
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .black
        tabBar.backgroundColor = .clear
        tabBar?.delegate = self
        
        // ✅ Generate indicator image sized to one tab item
        let itemWidth  = UIScreen.main.bounds.width / CGFloat(tabBar.items?.count ?? 1)
        let itemHeight = tabBar.frame.height > 0 ? tabBar.frame.height : 49
        
        tabBar.selectionIndicatorImage = makeImage(
            color: .white,
            size:  CGSize(width: itemWidth, height: itemHeight),
            cornerRadius: 0
        )
        
        tabBar.selectedItem = tabBar.items?[0]
        
        switchVc(homeVC)
    }
    func switchVc(_ vc: UIViewController) {
        
        if let current = currentVC {
            current.view.removeFromSuperview()
            current.removeFromParent()
        }
        
        addChild(vc)
        vc.view.frame = containerview.bounds
        containerview.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        currentVC = vc
    }

    // ✅ Generates a UIImage from a color — no static views needed
    private func makeImage(color: UIColor, size: CGSize, cornerRadius: CGFloat = 0) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            color.setFill()
            UIBezierPath(roundedRect: CGRect(origin: .zero, size: size),
                         cornerRadius: cornerRadius).fill()
        }
    }
}


extension TabBarViewController : UITabBarControllerDelegate,UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch item.tag {
            
        case 0:
            switchVc(homeVC)

        default:
            break
        }
    }
    
}
