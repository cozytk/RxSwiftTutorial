//
//  ViewController.swift
//  HelloRxSwift
//
//  Created by taekkim on 2022/10/02.
//

import UIKit

import RxSwift
import RxCocoa

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _ = Observable.from(optional: [1,2,3,4,5])
    }
}

