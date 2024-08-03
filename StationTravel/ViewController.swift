//
//  ViewController.swift
//  StationTravel
//
//  Created by 亀川敦躍 on 2024/04/20.
//

import UIKit
import Foundation
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var stationLabel: UILabel!
    @IBOutlet var adressLabel: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var prefecturePickerView: UIPickerView!
    
    let locationManager = CLLocationManager()
    
    var searchedMapItems:[MKMapItem] = []
    var didStartUpdatingLocation = false
    
    var csvBundle: String?
    var csvData: String?
    var csvArray: [String] = []
    var exArray: [String] = []
    
    var randomm = 0
    
    let geocoder = CLGeocoder()
    let annotation = MKPointAnnotation()
    
    var sliderValue :Int = 1
    
    var annotationView: MKAnnotationView!
    
    
    var stationData = ""
    var ekimeiLong : Int!
    
    var stationLng : Double!
    var stationLat : Double!
    var array :[String]!
    var station : String!
    
    var nowLat:Double!
    var nowLon:Double!
    
    var prefecture = "範囲指定なし"
    
    let prefectureArray: [String] = ["範囲指定なし","北海道","青森県","秋田県","岩手県","山形県","宮城県","福島県","新潟県","群馬県","栃木県","茨城県","千葉県","埼玉県","東京都","神奈川県","山梨県","静岡県","愛知県","岐阜県","富山県","石川県","福井県","三重県","滋賀県","和歌山県","奈良県","京都府","大阪府","兵庫県","鳥取県","島根県","岡山県","広島県","山口県","香川県","徳島県","高知県","愛媛県","福岡県","佐賀県","長崎県","大分県","熊本県","宮崎県","鹿児島県","沖縄県"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self // CLLocationManagerDelegateプロトコルを使用するためにdelegateをViewControllerクラスに設定する。
        locationManager.requestWhenInUseAuthorization() // 位置情報の許可設定を通知する。
   
        self.locationManager.delegate = self
        mapView.delegate = self
        initLocation() //位置情報取得の関数の呼び出し
        
        csvBundle = Bundle.main.path(forResource: "List", ofType: "csv")!
        do {
            csvData = try String(contentsOfFile: csvBundle!, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to read file")
        }
        csvArray = (csvData?.components(separatedBy: "\n"))!
        
        LocationManager()
        
        prefecturePickerView.dataSource = self
        prefecturePickerView.delegate = self
        
        exArray = csvArray
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated) // 親クラスのメソッドを呼び出す
        locationManager.stopUpdatingLocation()
        
        print("アホ")
        
    }
    
    
    
    @IBAction func tapButton () {
        
        locationManager.requestLocation()
        print(exArray.count)
        randomm = Int.random(in: 0..<exArray.count)
        stationData = exArray[randomm]
        array = stationData.components(separatedBy: ",")
        
        print(array)
        
        guard let latitude = Double(array[2].trimmingCharacters(in: .whitespacesAndNewlines)),
              let longitude = Double(array[3].trimmingCharacters(in: .whitespacesAndNewlines)) else {
            //trimmingCharacters(in: .whitespacesAndNewlines)で、文字列の前後の空白や改行を削除したら文字列からDoubleへの変換が成功しやすいらし
            print("ダメそうでつ")
            return
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        print(latitude)
        print(longitude)
        
        adressLabel.text = array[1]
        
        UserDefaults.standard.set(latitude, forKey: "sLat")
        UserDefaults.standard.set(longitude, forKey: "sLon")
        
        
        station = String(array[0].dropLast())
        stationLabel.text = station
        
        UserDefaults.standard.set(station, forKey: "station")
        
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        let cr = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(cr, animated: true)
        
        let pa = MKPointAnnotation()
        pa.title = station
        pa.coordinate = loc.coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pa)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = station
        annotation.subtitle = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
        mapView.addAnnotation(annotation)
        
        
    }
    
    @IBAction func goButton() {
        if (nowLat != nil)&&nowLon != nil {
            UserDefaults.standard.set(nowLat, forKey: "Lat")
            UserDefaults.standard.set(nowLon, forKey: "Lon")
            self.performSegue(withIdentifier: "Going", sender: self)
        } else {
            let alert = UIAlertController(title: "位置情報の使用を許可していください", message: "わかったか？", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "わかりましたすいませんでした", style: .default))
                self.present(alert, animated: true, completion: nil)
        }
        
        
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return prefectureArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == prefecturePickerView {
            return prefectureArray[row]
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int){
        // 選択された際に呼ばれる
        // rowには選択された行数インデックスが格納されている
        print(prefectureArray[row])
        prefecture = prefectureArray[row]
        if prefecture == "範囲指定なし" {
            exArray = csvArray
        } else {
            exArray = csvArray.filter { $0.contains(prefecture)
            }
        }
        
    }
    
    
    class LocationManager: NSObject, CLLocationManagerDelegate {
        let manager = CLLocationManager()
        
        override init() {
            super.init()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }
        
    }
    
    private func initLocation() {
        
        DispatchQueue.global().async {
            if !CLLocationManager.locationServicesEnabled() {
                print("No location service")
                return
            }
        }

        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            //ユーザーが位置情報の許可をまだしていないので、位置情報許可のダイアログを表示する
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied: //許可が出てる
            showPermissionAlert()
        case .authorizedAlways, .authorizedWhenInUse: //許可を得れなかった
            if !didStartUpdatingLocation{
                didStartUpdatingLocation = true
                locationManager.startUpdatingLocation()
            }
        @unknown default:
            break
        }
    }
    
    
    
}

extension ViewController: CLLocationManagerDelegate {
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let loc = locations.last else { return }
        
        print("location: \(loc)")
        print("緯度!!: \(loc.coordinate.latitude)")
        print("経度!!: \(loc.coordinate.longitude)")
        nowLat = loc.coordinate.latitude
        nowLon = loc.coordinate.longitude
        
        
        let pointLocation = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報取得エラー: \(error)")
    }
}

