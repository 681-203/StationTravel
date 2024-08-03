//
//  GameViewController.swift
//  StationTravel
//
//  Created by 亀川敦躍 on 2024/06/08.
//

import UIKit
import MapKit
import CoreLocation
import Foundation
import RealmSwift

class GameViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    //位置情報取得関連の変数
    var didStartUpdatingLocation = false
    
    let date = Date()
    
    var Lon :Double!
    var Lat :Double!
    var sLat :Double!
    var sLon :Double!
    
    
    
    var points :Double!
    
    var station:String!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPermissionAlert()
        
        locationManager.delegate = self
        
        Lat = UserDefaults.standard.double(forKey: "Lat")
        Lon = UserDefaults.standard.double(forKey: "Lon")
        sLat = UserDefaults.standard.double(forKey: "sLat")
        sLon = UserDefaults.standard.double(forKey: "sLon")//駅の緯度経度を取得
        station = UserDefaults.standard.string(forKey: "station")
        
        locationManager.startUpdatingLocation() //
        
        guard let LatOp = Lat else { return }
        guard let LonOp = Lon else { return }
        guard let sLatOp = sLat else { return }
        guard let sLonOp = sLon else { return }
        
        mapView.showsUserLocation = true
        
        _ = MKCoordinateRegion()
        
        let squaredDistance = pow(sLatOp - LatOp, 2) + pow(sLonOp - LonOp, 2)
        print(abs(sqrt(squaredDistance)))

        points = pow(2,abs(sqrt(squaredDistance)))
        
        UserDefaults.standard.set(points, forKey: "points")
        
        addPinToMap()
        
        print("獲得予想ポイント:",points)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func dismiss2() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
//
    
    func addPinToMap() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: sLat, longitude: sLon) // 東京タワーの座標
        pin.title = station
        mapView.addAnnotation(pin)
    }
    
    private func showPermissionAlert(){
        //位置情報が制限されている/拒否されている
        let alert = UIAlertController(title: "位置情報の取得", message: "設定アプリから位置情報の使用を許可して下さい。", preferredStyle: .alert)
        let goToSetting = UIAlertAction(title: "設定アプリを開く", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("キャンセル", comment: ""), style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(goToSetting)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
     
}

extension GameViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let loc = locations.last else { return }
        
        print("location: \(loc)")
        print("緯度おおお: \(loc.coordinate.latitude)")
        print("経度おおお: \(loc.coordinate.longitude)")
        
        
        let pointLocation = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        
        guard let location = locations.last else { return } // 最新の位置情報が取得できない場合は処理を終了

        // 現在地の緯度と経度を取得
        let nowLat = location.coordinate.latitude
        let nowLon = location.coordinate.longitude

        // 現在地と目標地点の距離を計算
        let distanceLat = abs(nowLat - sLat)
        let distanceLon = abs(nowLon - sLon)

        // 目標地点との距離が500m以内の場合のみ処理を実行
        guard distanceLat <= 0.005 && distanceLon <= 0.005 else { return }

        // 距離情報をコンソールに出力
        print("現在地と目標地点の距離: 緯度: \(distanceLat), 経度: \(distanceLon)")
        
        

        // セグエを実行
        self.performSegue(withIdentifier: "Goal", sender: self)
        
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報取得エラー: \(error)")
    }
}


