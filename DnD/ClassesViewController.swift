//
//  ClassesViewController.swift
//  DnD
//
//  Created by Aleksey Nikolaenko on 14.07.2022.
//

import UIKit
import Combine

class ClassesViewController: UIViewController {

    private lazy var viewModel: ClassesViewModel = {
        let viewModel = ClassesViewModel()
        return viewModel
    }()
    
    private var tableDataSouce: [String] = []
    private var cancellables: Set<AnyCancellable> = []

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Classes"
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
        viewModel.$classes.sink { [weak self] newClasses in
            self?.tableDataSouce = newClasses.map { $0.name }
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

extension ClassesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSouce.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = tableDataSouce[indexPath.row]
        return cell
    }
}

extension ClassesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classModel = viewModel.classes[indexPath.row]
        navigationController?.pushViewController(
            ClassDetailsViewController(classModel: classModel),
            animated: true
        )
    }
}


