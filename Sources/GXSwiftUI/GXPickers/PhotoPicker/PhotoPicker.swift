//
//  ImagePicker.swift
//  
//
//  Created by Anton on 27.07.2021.
//

import Foundation
import SwiftUI

/// Структура для отображения камеры
public struct PhotoPicker: UIViewControllerRepresentable {
    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: PhotoPicker
        var handlePickedImage: (URL) -> Void
        
        /// Init
        /// - Parameters:
        ///   - parent: родитель для класса Coordinator
        ///   - handlePickedImage: обработчик, который передает url сделанной фотографии
        init(parent: PhotoPicker, handlePickedImage: @escaping (URL) -> Void) {
            self.parent = parent
            self.handlePickedImage = handlePickedImage
        }
        
        /// Функция для выбора медиафайла при помощи UIImagePickerController
        /// - Parameters:
        ///   - picker: Контроллер представления, который управляет системными интерфейсами для съемки фотографий
        ///   - info: Ключи, которые вы используете для извлечения информации  из словаря о фотографии.
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            if let imageUrl = info[.imageURL] as? URL {
                handlePickedImage(imageUrl)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    /// Изображение, которое берется с камеры устройства
    @Binding var image: UIImage?
    /// Урл файла, из которого при необходимости можно посмотреть интересующие свойства файла,
    /// воспользовавшись ImageUrlHelper (имя, размер, дата создания файла)
    var handlePickedImage: (URL) -> Void
    
    /// Init
    /// - Parameters:
    ///   - image: Изображение, которое берется с камеры устройства
    ///   - handlePickedImage: Урл файла, из которого при необходимости можно посмотреть интересующие свойства файла
    public init(image: UIImage?, handlePickedImage: @escaping (URL) -> Void) {
        self.image = image
        self.handlePickedImage = handlePickedImage
    }
    
    /// Функция создает координатор для связи с контроллером
    /// - Returns: Координатор
    public func makeCoordinator() -> Coordinator {
        return PhotoPicker.Coordinator(parent: self, handlePickedImage: handlePickedImage)
    }
    
    /// Функция создает  объект  UIKit view controller и настраивает его, вызывается один раз при его создании
    /// - Parameter context: Контекст, содержащий информацию о текущем состоянии системы
    /// - Returns: настроенный UIKit view controller
    public func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    /// Функция вызывается каждый раз, когда от SwiftUI поступают изменения состояния для обновления view controller
    /// - Parameters:
    ///   - : Настроенный UIKit view controller
    ///   - : Контекст, содержащий информацию о текущем состоянии системы
    public func updateUIViewController(_: UIImagePickerController, context _: UIViewControllerRepresentableContext<PhotoPicker>) {}
}
