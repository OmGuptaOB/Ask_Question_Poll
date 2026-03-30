//
//  AllQuestionListViewController.swift
//  Ask_Question_Poll
//
//  Created by OBMac-13 on 26/03/26.
//

import UIKit
import SCLAlertView

class AllQuestionListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var questions: [QuestionModel] = []
    var loader: SCLAlertViewResponder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle  = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        fetchQuestions()
//        setupBtn()
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaultsManager.isQuestionAdded{
            fetchQuestions()
        }
    }
    
    func fetchQuestions() {
        loader = showLoading(message: "")
        
        APIManager.shared.getAllQuestions { [weak self] response,error, isSuccess in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.loader?.close()
                if let error = error {
                    showError(error)
                    return
                }
                if isSuccess {
                    UserDefaultsManager.isQuestionAdded = false
                    let flat = response?.data?.result ?? []
                    print("Flat count: \(flat.count)")
                    
                    self.questions = flat
                    self.tableView.reloadData()
                } else {
                    showError(response?.message ?? "Failed to load questions")
                }
            }
        }
    }
}
extension AllQuestionListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAnalysisCell", for: indexPath) as! ViewAnalysisCell
        let question = questions[indexPath.row]
        cell.LabelQuestionDescription.text = question.description ?? ""
        return cell
    }
}
