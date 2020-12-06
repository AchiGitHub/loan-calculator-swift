//
//  SavingsModalViewController.swift
//  Finance Calculator App
//
//  Created by Achintha Ikiriwatte on 2020-12-06.
//

import UIKit

class SavingsModalViewController: UIViewController {

    var passedValue: String?
    var headerName: String?

    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var textValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerText.text = headerName
        textValue.text = passedValue
        // Do any additional setup after loading the view.
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
