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
   
    lazy var homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    lazy var LogoutVC = storyBoard.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController
    lazy var QuestionVC = storyBoard.instantiateViewController(withIdentifier: "QuestionsPageViewController") as! QuestionsPageViewController
    lazy var ViewAllQuestionVC = storyBoard.instantiateViewController(withIdentifier: "AllQuestionListViewController") as! AllQuestionListViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
        setupButtons()
//        fetchAndLoadQuestions()
        self.navigationController?.isNavigationBarHidden = true
        QuestionVC.shouldHideCloseButton = true
    }
    func setupTabbar() {
        selectTab(at: 1)
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
        case 0: switchVC(QuestionVC)
        case 1: switchVC(homeVC)
        case 2: switchVC(LogoutVC)
        case 3: switchVC(ViewAllQuestionVC)
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
//    func fetchAndLoadQuestions() {
//        APIManager.shared.viewQuestions { [weak self] response, error in
//            DispatchQueue.main.async {
//                if response?.code == 200 {
//                    let questions = response?.data?.result ?? []
//                    self?.QuestionVC.questions = questions
//                    
//                    // ✅ Set first page after data loads
//                    if let first = self?.QuestionVC.makeQuestionVC(at: 0) {
//                        self?.QuestionVC.setViewControllers(
//                            [first], direction: .forward, animated: false
//                        )
//                    }
//                }
//            }
//        }
//    }
}

