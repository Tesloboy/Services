//
//  ContentView.swift
//  Services
//
//  Created by Viktor Teslenko on 27.03.2024.
//

import SwiftUI

// Главное представление содержимого
struct ContentView: View {
    @ObservedObject var viewModel = ServicesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Сервисы")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 20) // Добавляем верхний отступ
                    .padding(.bottom, 10) // Добавляем нижний отступ
                
                List(viewModel.services) { service in
                    NavigationLink(destination: WebView(url: service.link)) {
                        ServiceRowView(service: service)
                    }
                    .listRowBackground(Color.black) // Устанавливаем черный фон для строки
                }
                .listStyle(PlainListStyle()) // Убираем отступы и разделители
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
            .background(Color.black.edgesIgnoringSafeArea(.all)) // Устанавливаем черный фон для всего экрана
            .alert(isPresented: .constant(!viewModel.errorMessage.isEmpty)) {
                Alert(title: Text("Ошибка"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

// Предпросмотр
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
