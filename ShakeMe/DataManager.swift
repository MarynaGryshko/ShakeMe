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
    let userDefaults = UserDefaults.standard

// MARK: Get data from network
    func fetchData() {
        
        let path = Const.urlString + Const.userQuestion
        
        guard let urlString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            self.delegate?.didFailWithError(error: "Can not create url string from \(path)")
            return
        }
        
        if let url = URL(string: urlString) {
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
    
//MARK: Working with default values
    
    func getDefaultMessages() -> [Message]?  {

        if let savedMessages = userDefaults.object(forKey: Const.keyToSaveDefaultMessages) as? Data {
            let decoder = JSONDecoder()
            if let loadedMessages = try? decoder.decode(Array.self, from: savedMessages) as [Message] {
                        return loadedMessages
                     } else {
                        return nil
                     }
                  } else {
                      return nil
                        }
    }
    
    func saveDefaultMessages(messageArray: [Message]?) {
        if messageArray != nil {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(messageArray) {
                userDefaults.set(encoded, forKey: Const.keyToSaveDefaultMessages)
            }
        } else {
            userDefaults.set(nil, forKey: Const.keyToSaveDefaultMessages)
        }
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
