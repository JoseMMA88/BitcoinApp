//
//  CoinManager.swift
//  Bitcoin
//
//  Created by Jose Manuel Malagón Alba on 22/10/2023.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String)
    func requestFailed(error: Error)
}

struct CoinData: Decodable {
    let rate: Double
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8B67C8C1-D940-4C85-B897-E3DBFA1FE13B"
    
    let currencyArray = ["AUD",
                         "BRL",
                         "CAD",
                         "CNY",
                         "EUR",
                         "GBP",
                         "HKD",
                         "IDR",
                         "ILS",
                         "INR",
                         "JPY",
                         "MXN",
                         "NOK",
                         "NZD",
                         "PLN",
                         "RON",
                         "RUB",
                         "SEK",
                         "SGD",
                         "USD",
                         "ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let url = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
        print(url)
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.delegate?.requestFailed(error: error)
                    return
                }
                
                if let safeData = data {
                    if let coinPrice = self.parseJson(coinData: safeData) {
                        DispatchQueue.main.async {
                            self.delegate?.didUpdatePrice(price: coinPrice)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJson(coinData: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let coinModel = try decoder.decode(CoinData.self, from: coinData)
            print(coinModel)
            let priceString = String(format: "%.2f", coinModel.rate)
            
            return priceString
            
        } catch {
            delegate?.requestFailed(error: error)
            return nil
        }
    }

    
}
