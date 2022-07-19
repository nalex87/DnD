//
//  ClassDetailsViewController.swift
//  DnD
//
//  Created by Aleksey Nikolaenko on 14.07.2022.
//

import UIKit
import Combine

class ClassDetailsViewController: UIViewController {
    
    private var classModel: ClassesViewModel.ClassModel!
    
    private lazy var viewModel: ClassDetailsViewModel = {
        let viewModel = ClassDetailsViewModel(classIndex: classModel.index)
        return viewModel
    }()
    
    private var tableDataSouce: [String] = []
    private var cancellables: Set<AnyCancellable> = []

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.register(ClassDetailViewCell.self, forCellReuseIdentifier: "ClassDetailViewCell")
        return tableView
    }()
    
    private lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        
        return alert
    }()

    convenience init(classModel: ClassesViewModel.ClassModel) {
        self.init()
        self.classModel = classModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "\(classModel?.name ?? "Class") details"
        view.addSubview(tableView)
        setupAutoLayout()
        bindViewModel()
    }
    
    private func showLoader() {
        present(alert, animated: false, completion: nil)
    }
    
    private func hideLoader() {
        alert.dismiss(animated: true, completion: nil)
    }

    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$spells.sink { [weak self] newSpells in
            self?.tableDataSouce = newSpells.map { $0.name }
            self?.tableView.reloadData()
        }.store(in: &cancellables)

        viewModel.$isFetching.sink { [weak self] isFetching in
            if isFetching {
                self?.showLoader()
            } else {
                self?.hideLoader()
            }
        }.store(in: &cancellables)
    }
}

extension ClassDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSouce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ClassDetailViewCell",
            for: indexPath) as! ClassDetailViewCell

        cell.config(spellModel: viewModel.spells[indexPath.row])
        return cell
    }
}
