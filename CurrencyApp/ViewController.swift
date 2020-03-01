//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Kato Ryota  on 5/01/20.
//  Copyright © 2020 Kato Ryota . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var countryPicker: UIPickerView!
    
    @IBOutlet weak var alartLabel: UILabel!
    
    let url = "http://apilayer.net/api/live?access_key=03dc4253384ee909ede5a0af5b62edde&currencies="
    let countryArray = ["--国を選択してください--","JPY","AUD","SGD","NZD","USD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","MXN","NOK","PLN","RON","RUB","SEK","ZAR"]
    
    var country = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        countryArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if countryArray[row]==countryArray[0]{
            alartLabel.isHidden = false
            alartLabel.text = "国を選択してください"
            countryLabel.text = "--"
            currencyLabel.text = "--"
            
        }else{
        country = countryArray[row]
        getPrice(url: url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        alartLabel.isHidden = true
    }
    
    func getPrice(url: String){
        print("succsess")
        Alamofire.request(url, method: .get).responseJSON{
            response in
                if response.result.isSuccess{
                    let priceJSON: JSON = JSON(response.result.value!)
                    print("clear")
                    self.updatePriceData(json: priceJSON)
                }else{
                    print(Error.self)
                    
                }
            
        }
    }
    
    
    func updatePriceData(json: JSON){
        
        if let valueResult = json["quotes"]["USD\(country)"].double {
                   if let jpyResult = json["quotes"]["USDJPY"].double{
                       let finalValue = round(jpyResult / valueResult * 1000) / 1000
                       currencyLabel.text = "\(finalValue)円"
                       print(country)
                       countryLabel.text = "1\(country)"
                   }
               }else {
                    currencyLabel.text = "Price not available"
               }
               
           }



}

