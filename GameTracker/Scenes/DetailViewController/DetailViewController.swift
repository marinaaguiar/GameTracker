//
//  DetailViewController.swift
//  GameTracker
//
//  Created by Marina Aguiar on 9/26/22.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var backButton: UIBarButtonItem!

    static let reuseIdentifier = "DetailViewController"

    var gameTitle: String = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = gameTitle
    }

    override func viewDidDisappear(_ animated: Bool) {
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {

        self.dismiss(animated: true)
    }
}
