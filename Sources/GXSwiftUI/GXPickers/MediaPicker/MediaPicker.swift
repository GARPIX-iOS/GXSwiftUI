//
//  MediaPicker.swift
//  PHPickerTest
//
//  Created by Anton on 28.07.2021.
//

import Foundation
import SwiftUI
import PhotosUI

/// Структура для отображения PHPickerViewController из UIKit, позволяет выбирать разные типы медиа файлов из пользовательской библиотеке  по отдельности или все вместе.
@available(iOS 14, *)
public struct MediaPicker: UIViewControllerRepresentable {
    /// Количество медиа-файлов, которое можно выбрать за раз
    /// Чтобы выбрать неограниченное количество файлов - укажи filesCount = 0
    var filesCount: Int
    /// Массив, в котором можно указать какие файлы можно выбирать: картинки, живые фото или видео
    /// Можно выбрать по-отдельности или все вместе
    var pickerFilter: [PHPickerFilter]
    /// Массив картинок, которые передаются из библиотеки
    @Binding var imageResult: [UIImage]
    /// Массив живых фото, которые передаются из библиотеки
    @Binding var livePhotoResult: [PHLivePhoto]
    /// Массив урлов видео файлов, которые передаются из библиотеки
    @Binding var videoResult: [URL]
    /// Переменная для отображения/закрытия библиотеки
    @Binding var isPresented: Bool
    
    /// Init
    /// - Parameters:
    ///   - filesCount: Количество медиа-файлов, которое можно выбрать за раз, по-умолчанию filesCount = 0 для неграниченного выбора
    ///   - pickerFilter: Массив, в котором можно указать какие файлы можно выбирать: картинки, живые фото или видео, по-умолчанию выбран тип картинок
    ///   - imageResult: Массив картинок, которые передаются из библиотеки, необязательный параметр
    ///   - livePhotoResult: Массив живых фото, которые передаются из библиотеки, необязательный параметр
    ///   - videoResult: Массив урлов видео файлов, которые передаются из библиотеки, необязательный параметр
    ///   - isPresented: Переменная для отображения/закрытия библиотеки
    public init(
        filesCount: Int = 0,
        pickerFilter: [PHPickerFilter] = [.images],
        imageResult: Binding<[UIImage]> = .constant([]),
        livePhotoResult: Binding<[PHLivePhoto]> = .constant([]),
        videoResult: Binding<[URL]> = .constant([]),
        isPresented: Binding<Bool>) {
        self.filesCount = filesCount
        self.pickerFilter = pickerFilter
        _imageResult = imageResult
        _livePhotoResult = livePhotoResult
        _videoResult = videoResult
        _isPresented = isPresented
    }
    
    /// Функция для настройки конфигурации медиа пикера, принимает параметры из инициализатора filesCount и pickerFilter
    /// - Returns: Настройки для медиа пикера
    func configurePicker() -> PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .any(of: pickerFilter)
        configuration.selectionLimit = filesCount
        return configuration
    }
    
    /// Функция для создания UIViewController, вызывается один раз
    /// - Parameter context: Контекст, который мы помещаем в UIViewController
    /// - Returns: UIViewController с нашим контекстом - PHPickerViewController
    public func makeUIViewController(context: Context) -> some UIViewController {
        let photoPickerViewController = PHPickerViewController(configuration: configurePicker())
        photoPickerViewController.delegate = context.coordinator
        return photoPickerViewController
    }
    
    /// Функция для обновления UIViewController в случае изменения контекста
    /// - Parameters:
    ///   - uiViewController: UIViewController
    ///   - context: Контекст, который мы помещаем в UIViewController
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    /// Функция создает координатор для связи с контроллером
    /// - Returns: Координатор
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    public class Coordinator: PHPickerViewControllerDelegate {
        private let parent: MediaPicker
        /// Строковая переменная
        private var videoType = "com.apple.quicktime-movie"
        
        init(_ parent: MediaPicker) {
            self.parent = parent
        }
        
        fileprivate func getUIImages(_ mediaItem: PHPickerResult) -> Progress {
            return mediaItem.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                if let error = error {
                    print("Can't load image \(error.localizedDescription)")
                } else if let image = newImage as? UIImage {
                    /// если да, то добавляем изображение в массив изображений
                    self?.parent.imageResult.append(image)
                }
            }
        }
        
        fileprivate func getLivePhotos(_ mediaItem: PHPickerResult) -> Progress {
            return mediaItem.itemProvider.loadObject(ofClass: PHLivePhoto.self) { [weak self] newLivePhoto, error in
                if let error = error {
                    print("Can't load live photo \(error.localizedDescription)")
                } else if let livePhoto = newLivePhoto as? PHLivePhoto {
                    /// если да, то добавляем его в массив живых фотографий
                    self?.parent.livePhotoResult.append(livePhoto)
                }
            }
        }
        
        fileprivate func getVideoUrls(_ mediaItem: PHPickerResult) {
            mediaItem.itemProvider.loadItem(forTypeIdentifier: videoType, options: nil) { [weak self] url, error in
                if let error = error {
                    print("Can't load video \(error.localizedDescription)")
                } else if let videoUrl = url as? URL {
                    /// если да, добавляем его урл в соответствующий массив
                    self?.parent.videoResult.append(videoUrl)
                }
            }
        }
        
        /// Функция для обработки выбранных пользователем файлов из библиотеки
        /// - Parameter results: Выбранные пользователем медиа-файлы
        fileprivate func getFiles(from results: [PHPickerResult]) {
            for mediaItem in results {
                /// проверяем, является ли файл - изображением/картинкой
                if mediaItem.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    getUIImages(mediaItem)
                    /// проверяем, является ли файл живой фотографией
                } else if mediaItem.itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
                    getLivePhotos(mediaItem)
                    /// проверяем, является ли файл видео файлом
                } else if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(videoType) {
                    getVideoUrls(mediaItem)
                } else {
                    print("Can't load asset")
                }
            }
        }
        
        /// Функция, которая вызывается при непосредственном выборе медиа-файлов в библиотеке
        /// - Parameters:
        ///   - picker: PHPickerViewController
        ///   - results: Выбранные медиа-файлы из библиотеки
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            getFiles(from: results)
            parent.isPresented = false
        }
    }
}
