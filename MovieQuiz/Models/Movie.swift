//
//  Movie.swift
//  MovieQuiz
//
//  Created by Andy Bigalinov on 24.09.2023.
//

import UIKit

struct Actor: Codable {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}

struct Movie: Codable {
  let id: String
  let rank: String
  let title: String
  let fullTitle: String
  let year: String
  let image: String
  let crew: String
  let imDbRating: String
  let imDbRatingCount: String
}

struct Top: Decodable {
    let items: [Movie]
}

//struct Actor: Codable {
//    let id: String
//    let image: String
//    let name: String
//    let asCharacter: String
//}
//struct Movie: Codable {
//    let id: String
//    let title: String
//    let year: Int
//    let image: String
//    let releaseDate: String
//    let runtimeMins: Int
//    let directors: String
//    let actorList: [Actor]
//    
//    enum CodingKeys: CodingKey {
//        case id, title, year, image, releaseDate, runtimeMins, directors, actorList
//    }
//    
//    enum ParseError: Error {
//        case yearFailure
//        case runtimeMinsFailure
//    }
//    
//    init(from decoder: Decoder) throws {
//        // создаем контейнер, который будет содержать все поля будущей структуры. Оттуда мы и будем доставать значения по ключам
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        id = try container.decode(String.self, forKey: .id)
//        title = try container.decode(String.self, forKey: .title)
//        
//        let year = try container.decode(String.self, forKey: .year)
//        guard let yearValue = Int(year) else {
//            throw ParseError.yearFailure
//        }
//        self.year = yearValue
//        
//        image = try container.decode(String.self, forKey: .image)
//        releaseDate = try container.decode(String.self, forKey: .releaseDate)
//        
//        let runtimeMins = try container.decode(String.self, forKey: .runtimeMins)
//        guard let runtimeMinsValue = Int(runtimeMins) else {
//            throw ParseError.runtimeMinsFailure
//        }
//        self.runtimeMins = runtimeMinsValue
//        
//        directors = try container.decode(String.self, forKey: .directors)
//        
//        actorList = try container.decode([Actor].self, forKey: .actorList)
//    }
//}
