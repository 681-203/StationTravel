//
//  HomeViewController.swift
//  StationTravel
//
//  Created by 亀川敦躍 on 2024/07/27.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var sssButton:UIButton!
    @IBOutlet var recordButton:UIButton!
    
    
    @IBAction func tapButton () {
        self.performSegue(withIdentifier: "start", sender: self)
    }
    
    @IBAction func record() {
        self.performSegue(withIdentifier: "record", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
