//
//  RatesApiService.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

protocol RatesApiServiceProtocol {
    func get(completion: @escaping () -> Void)
}

final class RatesApiService: RatesApiServiceProtocol {

    func get(completion: @escaping () -> Void) {
        
        guard let url = UrlBuilder.albums.build() else {
            return //completion(.failure(.urlCreation))
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
//            let parser = ResponseParser(data: data)
//            let result = parser.parse()

            DispatchQueue.main.async {
                completion()
            }
        }
        task.resume()
    }
}
