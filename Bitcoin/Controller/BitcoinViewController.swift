//
//  ViewController.swift
//  Bitcoin
//
//  Created by Jose Manuel Malagón Alba on 22/10/2023.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectedCurrencyLabel: UILabel!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    //MARK: - Variables
    
    var coinManager = CoinManager()
 
    //MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        coinManager.delegate = self
        
        selectedCurrencyLabel.text = coinManager.currencyArray[0]
        coinManager.getCoinPrice(for: coinManager.currencyArray[0])
        
    }
    
    private func loadCurrencies() {
        
    }


}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrencyLabel.text = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }
    
    
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(price: String) {
        priceLabel.text = price
    }
    
    func requestFailed(error: Error) {
        print(error)
    }
}

