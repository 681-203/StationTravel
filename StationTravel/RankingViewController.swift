//
//  RankingViewController.swift
//  StationTravel
//
//  Created by 亀川敦躍 on 2024/07/27.
//

import UIKit
import RealmSwift

class RankingViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    
    let realm = try! Realm()
    var record: [saveData] = []
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toHomeButton: UIButton!
    @IBOutlet var clearButton : UIButton!
    
    @IBAction func cleareeee () {
        
    }
    
    @IBAction func toHome () {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ランキング？")
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "ScoreCell")
        
        record = readItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! ScoreTableViewCell
        let item: saveData = record[indexPath.row]
        cell.setCell(station: item.station, point: item.point, Date: item.date)
        
        return cell
    }
    
    func readItems() -> [saveData] {
        return Array(realm.objects(saveData.self))
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
