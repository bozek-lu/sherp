//
//  ResponseParser.swift
//  sherp
//
//  Created by Łukasz Bożek on 02/08/2021.
//

import Foundation

struct ResponseParser {
    let data: Data?
}

extension ResponseParser {
    func parse() -> Result<SomeDto, ApiError> {
        guard let data = data else {
            return .failure(.dataParsing)
        }

        let decoder = JSONDecoder()

        guard let dto = try? decoder.decode(SomeDto.self, from: data) else {
            return .failure(.dataParsing)
        }

        return .success(dto)
    }
}
