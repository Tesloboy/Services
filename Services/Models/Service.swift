//
//  Service.swift
//  Services
//
//  Created by Viktor Teslenko on 28.03.2024.
//

import Foundation

// Модель для сервиса
struct Service: Identifiable, Decodable {
    var id = UUID() // Идентификатор
    let name: String // Название
    let description: String // Описание
    let iconURL: URL // Адрес иконки
    let link: URL // Адрес ссылки

    // Связываем свойства структуры с соответствующими ключами в JSON
    private enum CodingKeys: String, CodingKey {
        case name, description, link, iconURL = "icon_url"
    }
}
