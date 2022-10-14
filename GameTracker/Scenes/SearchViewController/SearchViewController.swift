//
//  SearchViewController.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/14/22.
//

import UIKit

class SearchViewController: UIViewController {
    static let reuseIdentifier = "SearchViewController"

    private lazy var searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 300, 20))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        searchBar.becomeFirstResponder()
    }

    func setupNavBar() {
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(backButtonSelected))
        searchBar.placeholder = "Search game"
        let searchBarItem = UIBarButtonItem(customView: searchBar)

        navigationItem.leftBarButtonItems = [backButtonItem, searchBarItem]
    }

    @objc func backButtonSelected() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        print("backSelected")
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("refresh the view with filtered content")
    }
}
