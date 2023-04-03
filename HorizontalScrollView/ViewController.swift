//
//  ViewController.swift
//  HorizontalScrollView
//
//  Created by Nikolay Trofimov on 03.04.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var filterView: FilterView!
    let filterDataSource = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterView.dataSource = filterDataSource
    }


}

