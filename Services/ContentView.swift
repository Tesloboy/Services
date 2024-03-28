//
//  ContentView.swift
//  Services
//
//  Created by Viktor Teslenko on 27.03.2024.
//

import SwiftUI
import Combine
import WebKit

//Модель для сервиса
struct Service: Identifiable, Decodable {
    var id = UUID() // Идентификатор
    let name: String // Название
    let description: String // Описание
    let iconURL: URL // Адрес иконки
    let link: URL // Адрес ссылки

    //Связываем свойства структуры с соответствующими ключами в JSON
    private enum CodingKeys: String, CodingKey {
        case name, description, link, iconURL = "icon_url"
    }
}

// Модель для управления данными сервисов
class ServicesViewModel: ObservableObject {
    @Published var services: [Service] = [] //Св-во для хранения массива сервисов
    private var cancellable: AnyCancellable? // Переменная для хранения подписки

    init() {
        fetchServices() // Запускаем загрузку данных при инициализации
    }

    // Метод для загрузки данных о сервисах из JSON
    func fetchServices() {
        guard let url = URL(string: "https://publicstorage.hb.bizmrg.com/sirius/result.json") else {
            return // Возвращаемся, если URL недоступен
        }

        // Создаем подписку для загрузки данных из URL и обработки ошибок
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ResponseData.self, decoder: JSONDecoder())
            .map { $0.body.services } // Извлекаем массив сервисов из JSON-ответа
            .replaceError(with: []) // Заменяем ошибки пустым массивом
            .receive(on: DispatchQueue.main) // Получаем данные на главной очереди
            .assign(to: \.services, on: self) // Присваиваем полученные данные свойству services
    }
}



// Строки сервисов
struct ServiceRow: View {
    let service: Service // Сервис, который нужно отобразить

    var body: some View {
        HStack {
            AsyncImage(url: service.iconURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView() // Отображаем индикатор загрузки в случае отсутствия изображения.
            }
            .padding(.trailing, 10) // Отступ справа от изображения

            VStack(alignment: .leading, spacing: 4) {
                Text(service.name)
                    .font(.headline)
                    .foregroundColor(.white) // Цвет названия
                Text(service.description)
                    .font(.subheadline)
                    .foregroundColor(.white) //Цвет описания
                    .lineLimit(2) // Ограничиваем описание двумя строками
            }
        }
    }
}

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
                        ServiceRow(service: service)
                    }
                    .listRowBackground(Color.black) // Устанавливаем черный фон для строки
                }
                .listStyle(PlainListStyle()) // Убираем отступы и разделители
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
            .background(Color.black.edgesIgnoringSafeArea(.all)) // Устанавливаем черный фон для всего экрана
            
        }
    }
}


// Отображение веб-вью
struct WebView: View {
    let url: URL
    
    var body: some View {
        WebViewWrapper(url: url)
            .edgesIgnoringSafeArea(.all) // Игнорируем безопасные области, чтобы веб-вью занимало все пространство
    }
}

// Обертка для UIViewRepresentable, чтобы веб-вью могло быть использовано в SwiftUI
struct WebViewWrapper: UIViewRepresentable {
    let url: URL
    
    // Создание и конфигурация WKWebView
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url)) // Загрузка URL в веб-вью
        return webView
    }
    
    // Обновление веб-вью (здесь не используется, но требуется для UIViewRepresentable)
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}


// Модель данных для декодирования JSON-ответа
struct ResponseData: Decodable {
    let body: Body
}

// Вспомогательная структура для декодирования списка сервисов из JSON
struct Body: Decodable {
    let services: [Service]
}

//Предпросмотр
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
