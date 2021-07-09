//
//  ViewController.swift
//  MapAndProtocol
//
//  Created by 阿迦井翔 on 2020/09/11.
//  Copyright © 2020 kakeru.geek. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, SearchLocationDeregate, UITextFieldDelegate {
    
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    @IBOutlet weak var mapView: MKMapView!
    var locManager: CLLocationManager!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var serchText: UITextField!
    
    var addressString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingButton.backgroundColor = .white
        settingButton.layer.cornerRadius = 20.0
        
        serchText.delegate = self
        
        // ロングタップを検知
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(recognizeLongPress(sender:)))
        //MapViewにリスナーを登録
        self.mapView.addGestureRecognizer(longPress)
        
    }
    
    @IBAction func longPressTap(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            // タップを開始した
            
        } else if sender.state == .ended {
            // タップを終了した
            
            let tapPoint = sender.location(in: view)
            // タップした位置(CGPoint)を指定してMKMapView上の緯度、経度を取得
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            // 緯度
            let lat = center.latitude
            // 経度
            let log = center.longitude
            // 緯度、経度から住所に変換
            convert(lat: lat, log: log)
        }
        
    }
    
    func convert(lat:CLLocationDegrees, log:CLLocationDegrees) {
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: log)
        
        // クロージャー
        geocoder.reverseGeocodeLocation(location) { (placeMark, error) in
            
            if let placeMark = placeMark {
                
                if let pm = placeMark.first {
                    
                    if pm.administrativeArea != nil || pm.locality != nil {
                        
                        self.addressString = pm.name! + pm.administrativeArea! + pm.locality!
                        
                    } else {
                        
                        self.addressString = pm.name!
                        
                    }
                    
                    self.addressLabel.text = self.addressString
                }
                
            }
            
        }
        
    }
    
    @IBAction func goToSearchVC(_ sender: Any) {
        // 画面遷移
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    // 値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "next" {
            let nextVC = segue.destination as! NextViewController
            nextVC.delegate = self
        }
    }
    
    // 任されたデリゲートメソッド
    func searchLocation(idoValue: String, keidoValue: String) {
        
        if idoValue.isEmpty != true && keidoValue.isEmpty != true {
            
            let idoString = idoValue
            let keidoString = keidoValue
            
            // 緯度、軽度からコーディネート
            let coordinate = CLLocationCoordinate2DMake(Double(idoString)!, Double(keidoString)!)
            
            // 表示する範囲の指定
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            
            // 領域を指定
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            // 領域をmapViewに設定
            mapView.setRegion(region, animated: true)
            
            // 緯度、経度から住所へ変換
            convert(lat: Double(idoString)!, log: Double(keidoString)!)
            
            // ラベルに表示
            addressLabel.text = addressString
            
        } else {
            
            addressLabel.text = "表示できません"
            
        }
    }
    
    //ロングタップした時に呼ばれる関数
    @objc func recognizeLongPress(sender: UILongPressGestureRecognizer) {
        //長押し感知は最初の1回のみ
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        
        // 位置情報を取得
        let location = sender.location(in: self.mapView)
        let coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        // 出力
        print(coordinate.latitude)
        print(coordinate.longitude)
        // タップした位置に照準を合わせる処理
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.region = region
        
        // ピンを生成
        let pin = MKPointAnnotation()
        pin.title = "タイトル"
        pin.subtitle = "サブタイトル"
        // タップした位置情報に位置にピンを追加
        pin.coordinate = coordinate
        self.mapView.addAnnotation(pin)
    }
    
    // 地域検索
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        serchText.resignFirstResponder()
        
        if let searchKey = serchText.text {
            
            print(searchKey)
            
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in
                
                if let unwrapPlacemarks = placemarks {
                    if let firstPlacemark = unwrapPlacemarks.first {
                        if let location = firstPlacemark.location {
                            let targetCoordinate = location.coordinate
                            print(targetCoordinate)
                            
                            let pin = MKPointAnnotation()
                            
                            pin.coordinate = targetCoordinate
                            pin.title = searchKey
                            self.mapView.addAnnotation(pin)
                            
                            
                            self.mapView.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.00)
                        }
                    }
                }
            })
        }
        return true
    }
    
    /* オプショナルバインディング-空じゃないかを判定する
     if 変数 != nil {
     
     }
     
     if let 変数 = 変数1 {
     
     }
     */
    
}

