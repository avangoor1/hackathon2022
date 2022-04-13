//
//  SecondViewController.swift
//  AnimalClassifier
//
//  Created by Ananya Vangoor on 1/5/22.
//

import UIKit

class SecondViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    var text = "Animal"
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "It's a \(text)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
