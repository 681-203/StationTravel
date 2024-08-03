//
//  GoalViewController.swift
//  StationTravel
//
//  Created by 亀川敦躍 on 2024/07/06.
//

import UIKit
import MapKit
import CoreLocation
import Foundation
import RealmSwift

class GoalViewController: UIViewController {
    
    var points: Double!
    let realm = try! Realm()
    
    var sLat :Double!
    var sLon :Double!
    var station :String!
    
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    
    @IBAction func tapButton () {
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        points = UserDefaults.standard.double(forKey: "points")
        station = UserDefaults.standard.string(forKey: "station")
        
        
        guard let point = points else { return }
        guard let station = station else { return }
        
        func saveRecord (item: saveData) {
            try! realm.write {
                realm.add(item)
            }
        }
        
        func save() {
            print("save関数動作")
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            let japanTime = formatter.string(from: Date())
            let item = saveData()
            item.station = station
            item.point = Int(point)
            item.date = japanTime
            saveRecord(item: item)
        }
        
        save()
        
        pointLabel.text = String(points)
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
