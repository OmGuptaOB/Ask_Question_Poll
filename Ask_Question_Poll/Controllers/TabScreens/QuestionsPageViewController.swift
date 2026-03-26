//
//  QuestionsPageViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 26/03/26.
//

import UIKit
import SCLAlertView

class QuestionsPageViewController: UIViewController {
    
    var questions: [QuestionModel] = []
    var currentIndex: Int = 0
    var shouldHideCloseButton: Bool = false
    var loader: SCLAlertViewResponder?

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
                fetchQuestions()
    }
    override func viewWillAppear(_ animated: Bool) {
        if questions.isEmpty || UserDefaultsManager.isQuestionAdded {
                fetchQuestions()
            }
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            // ✅ Recalculate cell size after layout — critical for full screen cells
            collectionView.collectionViewLayout.invalidateLayout()
            
            // ✅ Scroll to current index after layout
            if questions.count > currentIndex {
                collectionView.scrollToItem(
                    at: IndexPath(item: currentIndex, section: 0),
                    at: .centeredHorizontally,
                    animated: false
                )
            }
        }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        // ✅ Remove all spacing
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero
            layout.headerReferenceSize = .zero  // ✅ no header
            layout.footerReferenceSize = .zero  // ✅ no footer
        }
        collectionView.contentInset = .zero
        collectionView.scrollIndicatorInsets = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(
            UINib(nibName: "QuestionContainerCell", bundle: nil),
            forCellWithReuseIdentifier: "QuestionContainerCell"
        )
    }
    func fetchQuestions() {
        APIManager.shared.viewQuestions { [weak self] response, error in
            DispatchQueue.main.async {
                if response?.code == 200 {
                    let data = response?.data?.result ?? []
                    
                    if data.isEmpty {
                        if let self = self {
                            showNoDataAlert(on: self)
                        }
                        self?.loader?.close()
                        return
                    }
                    
                    self?.questions = data
                    self?.collectionView.reloadData()
                    print("Questions loaded: \(data.count)")

                    UserDefaultsManager.isQuestionAdded = false
                }
            }
        }
    }
}


extension QuestionsPageViewController: UICollectionViewDelegateFlowLayout ,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
//    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero  // ✅ no padding at start or end
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionContainerCell", for: indexPath) as! QuestionContainerCell
        
        let question = questions[indexPath.item]

        cell.configure(with: question, shouldHideClose: shouldHideCloseButton)
        
        return cell
    }
}
