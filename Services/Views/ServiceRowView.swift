//
//  ServiceRowView.swift
//  Services
//
//  Created by Viktor Teslenko on 28.03.2024.
//

import SwiftUI

// Представление строки сервиса
struct ServiceRowView: View {
    let service: Service
    
    var body: some View {
        HStack {
            AsyncImage(url: service.iconURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
            }
            .padding(.trailing, 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(service.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(service.description)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(2) // Ограничиваем описание двумя строками
            }
        }
    }
}
