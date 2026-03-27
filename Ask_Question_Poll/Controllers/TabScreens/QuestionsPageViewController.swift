//
//  QuestionsPageViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 26/03/26.
//

import UIKit
import SCLAlertView

class QuestionsPageViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var questions: [QuestionModel] = []
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        if questions.isEmpty || UserDefaultsManager.isQuestionAdded {
                fetchQuestions()
            }
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            collectionView.collectionViewLayout.invalidateLayout()
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

    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionContainerCell", for: indexPath) as! QuestionContainerCell
        
        let question = questions[indexPath.item]

        cell.configure(with: question)
        
        return cell
    }
}
