//
//  ViewController.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import UIKit

@MainActor
class FlickerImagesListViewController: UIViewController {
    
    let viewModel: FlickerImagesListViewModel
    private let searchBar = UISearchBar()
    private let editingDebounceThresholdInSeconds = 1.5
    var debounceTimer:Timer?

    private let imagesTable: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection  = false
        tableView.register(FlickrImageTableViewCell.self, forCellReuseIdentifier: FlickrImageTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    init(viewModel: FlickerImagesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Search flickr"
        
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search for anything..."
        searchBar.sizeToFit()
        searchBar.delegate = self
        imagesTable.tableHeaderView = searchBar
        
        view.addSubview(imagesTable)
        imagesTable.dataSource = self
        imagesTable.delegate = self
    
        viewModel.delegate = self
        addConstraints()
    }
    
    private func addConstraints() {
        let imagesTableConstraints = [
        imagesTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        imagesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        imagesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        imagesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(imagesTableConstraints)
    }
    
    private func reloadData() {
        Task {
            await MainActor.run {[weak self] in
                self?.imagesTable.reloadData()
            }
        }
    }
}

extension FlickerImagesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplayCellAt(indexPath.row)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlickrImageTableViewCell.identifier) as? FlickrImageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.config(viewModel.items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 330
        return cellHeight
    }
    
    private func searchFor(text: String) {
        guard !text.isEmpty,
              text.count >= 3 else {
            if text.isEmpty {
                viewModel.clearSearch()
            }
            return
        }
        
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: editingDebounceThresholdInSeconds, repeats: false) {[weak self] _ in
            Task {
                try await self?.viewModel.search(keyword: text)
            }
        }


    }
}

extension FlickerImagesListViewController: FlickerImagesListViewModelDelegate {
    func searchDidComplete() {
        reloadData()
    }
}

extension FlickerImagesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFor(text: searchText)
    }
}
