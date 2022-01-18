//
//  DataManager.swift
//  ShakeMe
//
//  Created by MARINA on 18.01.2022.
//

import Foundation

protocol DataManagerDelegate {
    func didUpdateData(_ dataManager: DataManager, message: Message)
    func didFailWithError(error: Error)
}

struct DataManager {
    
    var delegate: DataManagerDelegate?
     
    func fetchData() {
        let path = Const.urlString + Const.userQuestion
        let urlString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        
        ///FORCE UNWRAP!!
        if let url = URL(string: urlString!) {
                    let session = URLSession(configuration: .default)
                    let task = session.dataTask(with: url) { (data, response, error) in
                        if error != nil {
                            self.delegate?.didFailWithError(error: error!)
                            print(error)
                            return
                        }
                        if let safeData = data {
                            if let message = self.parseJSON(data: safeData) {
                                self.delegate?.didUpdateData(self, message: message)
                            }
                            print(data)
                        }
                    }
                    task.resume()
                }
    }
    
    func parseJSON(data: Data) -> Message? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Answer.self, from: data)
            return decodedData.magic
            } catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
    }
    
}

