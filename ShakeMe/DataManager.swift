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
    private let userDefaults = UserDefaults.standard
    
    //MARK: Get data from network of defaults
    func fetchData() {
        
        let path = ConstData.urlString + ConstData.userQuestion
        
        guard let urlString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            self.delegate?.didFailWithError(error: "Can not create url string from \(path)")
            return
        }
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    if let message = self.getHardcodedAnswer() {
                        self.delegate?.didUpdateData(self, message: message)
                    } else {
                        self.delegate?.didFailWithError(error: ConstData.noDataErrorDescription)
                    }
                    return
                }
                if let safeData = data {
                    if let message = self.parseJSON(data: safeData) {
                        self.delegate?.didUpdateData(self, message: message)
                    }
                }
            }
            task.resume()
        }
    }
    
    //Decode JSON object, create array of messages
    private func parseJSON(data: Data) -> Message? {
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
    
    //Get hardcoded messages from userDefaults
    func getDefaultMessages() -> [Message]?  {
        
        if let savedMessages = userDefaults.object(forKey: ConstData.keyToSaveDefaultMessages) as? Data {
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
    
    //Save hardcoded messages to userDefaults
    func saveDefaultMessages(messageArray: [Message]?) {
        if messageArray != nil {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(messageArray) {
                userDefaults.set(encoded, forKey: ConstData.keyToSaveDefaultMessages)
            }
        } else {
            userDefaults.set(nil, forKey: ConstData.keyToSaveDefaultMessages)
        }
    }
    
    //Get random answer from hardcoded
    private func getHardcodedAnswer() -> Message? {
        let message = getDefaultMessages()?.randomElement()
        return message
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
