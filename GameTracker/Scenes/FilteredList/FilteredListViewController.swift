//
//  FilteredListViewController.swift
//  GameTracker
//
//  Created by Marina Aguiar on 10/3/22.
//

import UIKit

class FilteredListViewController: UIViewController {

    static let reuseIdentifier = "FilteredListViewController"
    private let apiService = APIService()
    var maxPlaytime: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFilteredList()
    }
}

// MARK: - APIRequests

extension FilteredListViewController {

    func fetchFilteredList() {
        apiService.loadGameListFiltered(limitItems: 5, filterBy: .maxPlaytime, maxNumber: maxPlaytime, orderedBy: .average_user_rating) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
//                    print(data)
                }
                print("Load filtered list sucessfully")
            case .failure(let error):
                print(error)
            }
        }
    }
}
