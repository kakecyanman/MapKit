//
//  NextViewController.swift
//  MapAndProtocol
//
//  Created by 阿迦井翔 on 2020/09/11.
//  Copyright © 2020 kakeru.geek. All rights reserved.
//

import UIKit

protocol SearchLocationDeregate {
    func searchLocation(idoValue: String, keidoValue: String)
}

class NextViewController: UIViewController {
    
    @IBOutlet weak var idoTextField: UITextField!
    @IBOutlet weak var keidoTextField: UITextField!
    
    var delegate: SearchLocationDeregate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func okAction(_ sender: Any) {
        
        // 入力された値を取得
        let idoValue = idoTextField.text!
        let keidoValue = keidoTextField.text!
        
        // 両方のTFが空でなければ戻る
        
        if idoTextField.text != nil && keidoTextField.text != nil {
            
            // デリゲートメソッドの引数に入れる
            delegate?.searchLocation(idoValue: idoValue, keidoValue: keidoValue)
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}
