//
//  ResponseData.swift
//  Services
//
//  Created by Viktor Teslenko on 28.03.2024.
//

import Foundation

// Модель данных для декодирования JSON-ответа
struct ResponseData: Decodable {
    let body: Body
}

// Вспомогательная структура для декодирования списка сервисов из JSON
struct Body: Decodable {
    let services: [Service]
}
