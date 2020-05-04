//
//  NetworkGateway.swift
//  Air Scanner
//
//  Created by User on 29.04.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NetworkGateway {
    func send(url: String) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let url = URL(string: url)
        //let url = NSURL(string: urlString as String)
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = session.dataTask(with: url!) { data,response,error in
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    return
            }
            switch (httpResponse.statusCode) {
            case 200: //success response.
                break
            case 400:
                break
            default:
                break
            }
        }
        dataTask.resume()
    }
    
    func addRequest(request: AddDeviceRequest) {
        self.rxSend(request: request)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {response in
                print("\(response)")
            },onError:  {error in
                print("\(error)")
            })
        
    }
    
    func rxSend(request: AddDeviceRequest) -> Observable<AddDeviceResponse> {
        let req = URLRequest(url: URL(string: "http://en.wikipedia.org/w/api.php?action=parse&page=Pizza&format=json")!)
        let responseJSON = URLSession.shared.rx.json(request: req)
        
        // no requests will be performed up to this point
        // `responseJSON` is just a description how to fetch the response
        
        
        let responseModel = responseJSON
            .map({json in
                return try JSONDecoder().decode(AddDeviceResponse.self,from:  json as! Data)
            })
        
        
        return responseModel
        
    }
}
