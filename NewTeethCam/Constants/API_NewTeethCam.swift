//
//  API_NewTeethCam.swift
//  NewTeethCam
//
//  Created by Raja Vikram singh on 13/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import Foundation
import UIKit

class API_NewTeethCam
{
    static let shared = API_NewTeethCam()
    
    //    MARK:-func_API_Aive
    class func func_API_PostMethod(params:[String:Any], str_URL:String, completionHandler:@escaping ([String:Any])->())
    {
        print("params is:-",params)
        print("str_URL is:-",str_URL)
        
        var urlRequest = URLRequest(url:URL (string: k_API_CREATEURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody=try? JSONSerialization.data(withJSONObject: params, options: [])
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        urlRequest.httpBody = params.data(using:.utf8)
        URLSession.shared.dataTask(with: urlRequest)
        {
            (data_NTC, response_NTC, error_NTC) in
            
            if (response_NTC != nil)
            {
                print("response_NTC is:-",response_NTC ?? "response_NTC is nil")
                do
                {
                    let dict_JSON = try JSONSerialization.jsonObject(with: data_NTC!, options: .allowFragments) as! [String: Any]
                    print("json is:-",dict_JSON)
                    
                    completionHandler(dict_JSON)
                }
                catch let error as NSError
                {
                    print("Failed to load: \(error.localizedDescription)")
                    completionHandler([:])
                }
            }
            else
            {
                print("response_Aive is:-",response_NTC ?? "response_Aive is nil")
            }
            }.resume()
    }
    
    //    MARK: func_API_GetMethod
    class func func_API_GetMethod(str_URL:String, completionHandler:@escaping ([String:Any])->())
    {
    
        var urlRequest = URLRequest(url: URL (string:str_URL)!)
        urlRequest.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: urlRequest) { (mailasd, asdf, asf) in
            
        }
        
        print("str_URL is:- ",str_URL)
        
        URLSession.shared.dataTask(with: urlRequest)
        {
            (data_NTC, response_NTC, error_NTC) in
            do
            {
                let dict_JSON = try JSONSerialization.jsonObject(with: data_NTC!, options: []) as! [String: Any]
                print(dict_JSON)
                
                let data_JSON = NSKeyedArchiver.archivedData(withRootObject: dict_JSON)
                UserDefaults .standard .setValue(data_JSON, forKey: k_LOGIN_DATA)
                completionHandler(dict_JSON)
                
            }  catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                completionHandler([:])
            }
        }.resume()
    }
    
    
    class func func_API_PostMethod_With_Video(withImagearray ApiName: String?, withParameter dicparam: [String : Any]?, withImageArray imageArray: [UIImage], withVideoUrl videoString: String?, withCompletion completionHandler: @escaping (_ response: [String:Any]) -> Void) {

        let url = URL (string: ApiName!)
        print("url is:- ",url ?? "url is nil")
        
        var request: NSMutableURLRequest? = nil
        
        if let anURL = url {
            request = NSMutableURLRequest(url: anURL)
        }
        
        request?.httpMethod = "POST"
        var body = Data()
        let boundary = "---------------------------14737809831466499882746641449"
        
        print("dicparam is:- ",dicparam?.keys ?? "")
        
            var iii = 0
            for param: String? in (dicparam?.keys)! {
            
            if iii == dicparam?.count
            {
                break
            }
            
            iii = iii+1
            
            if let anEncoding = "\r\n--\(boundary)\r\n".data(using:String.Encoding.utf8) {
                body.append(anEncoding)
            }
            
            if let anEncoding = "Content-Disposition: form-data; name=\"\(param ?? "")\"\r\n\r\n".data(using: String.Encoding.utf8) {
                body.append(anEncoding)
            }
            
            if let aParam = dicparam![param!], let anEncoding = "\(aParam)".data(using: String.Encoding.utf8) {
                body.append(anEncoding)
            }
        }
    
    let contentType = "multipart/form-data; boundary=\(boundary)"
    request?.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
    var i: Int = 0
    
//    var bodyImage = Data()
        
//    for img in imageArray
//    {
//        if let anEncoding = "\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8) {
//            bodyImage.append(anEncoding)
//        }
//
//        if let aKey = dicparam!["imageKey"], let anEncoding = "Content-Disposition: form-data; name=\"\(aKey)[\(i)]\"; filename=\"imagee.png\"\r\n".data(using: String.Encoding.utf8) {
//                bodyImage.append(anEncoding)
//        }
//
//        if let anEncoding = "Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8) {
//            bodyImage.append(anEncoding)
//        }
//
//        if let anImg = UIImageJPEGRepresentation(img, 0.2) {
//            bodyImage.append(anImg)
//        }
//            i += 1
//    }
        
    if let anEncoding = "\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8) {
        body.append(anEncoding)
    }
        
    if let aKey = dicparam!["imageKey"], let anEncoding = "Content-Disposition: form-data; name=\"\(aKey)[]\"; filename=\"\"\r\n".data(using: String.Encoding.utf8) {
        body.append(anEncoding)
    }
        
    if let anEncoding = "Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8) {
        body.append(anEncoding)
    }
        
//    body.append(bodyImage)
        
    if let anEncoding = "\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8) {
        body.append(anEncoding)
    }
    if let anEncoding = "Content-Disposition: form-data; name=\"\("video")\"; filename=\"video.mp4\"\r\n".data(using: String.Encoding.utf8) {
        body.append(anEncoding)
    }
        
    if let anEncoding = "Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8) {
        body.append(anEncoding)
    }
        
    if let aString = NSData(contentsOfFile: videoString!) {
        body.append(aString as Data)
    }
        
    if let anEncoding = "\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8) {
        body.append(anEncoding)
    }
    
    request?.httpBody = body
    request?.addValue("\(UInt(body.count))", forHTTPHeaderField: "Content-Length")
    request?.addValue("Content-Type", forHTTPHeaderField: "application/json")
        
        let session = URLSession.shared
        let task: URLSessionDataTask? = session.dataTask(with: request! as URLRequest, completionHandler: {
            (data_NTC, response_NTC, error_NTC) in
            do
                {
                    let dict_JSON = try JSONSerialization.jsonObject(with: data_NTC!, options: []) as! [String: Any]
                    print(dict_JSON)
                    
                    let data_JSON = NSKeyedArchiver.archivedData(withRootObject: dict_JSON)
                    UserDefaults .standard .setValue(data_JSON, forKey: k_LOGIN_DATA)
                    completionHandler(dict_JSON)
                    
                }  catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    completionHandler([:])
                }
        })
        task?.resume()
        //    MARK:- Finish
    }
}



