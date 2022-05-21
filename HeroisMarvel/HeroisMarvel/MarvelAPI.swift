//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by Henrique Alves Batochi on 20/05/22.
//  Copyright © 2022 Eric Brito. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire

class MarvelAPI {
    
    static private let basePath = "https://gateway.marvel.com/v1/public/characters?"
    static private let privateKey = "f8be69c8ddf220330a472389d8039d575d3efc14"
    static private let publicKey = "b19d7f07fb95b36df4754955083fa139"
    static private let limit = 50
    
    class func loadHeroes(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?) -> Void) {
        let offset = page * limit
        let startsWith: String
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        } else {
            startsWith = ""
        }
        
        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredencials()
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else {
                onComplete(nil)
                return
            }
            do {
                let marvelInfo = try JSONDecoder().decode(MarvelInfo.self, from: data)
                onComplete(marvelInfo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private class func getCredencials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts + privateKey + publicKey).lowercased()
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
    
    
}
