//
//  RatingView.swift
//  swiftui_components
//
//  Created by Anton on 16.07.2021.
//

import SwiftUI

/// Рейтинг из выбранного количества элементов (по-умолчанию 5) с возможностью установки кастомной формы для одиночного элемента
/// в данном пакете представлена форма звезды - Star()
public struct GXRatingView<RatingMask: Shape>: View {
    /// величина рейтинга / оценка
    @Binding  var rating: Double
    /// форма для рейтинга (например звезда)
    var ratingMask: RatingMask
    /// количество элементов для оценки (по-умолчанию 5)
    var ratingElementCount: Int
    /// горизонтальное расстояние между элементами
    var horizontalSpace: CGFloat
    /// цвет для заполненного элемента
    var filledColor: Color
    /// цвет для незаполненного элемента
    var notFilledColor: Color
    /// дествие, которое происходит при тапе на элемент рейтинга
    var onDidRate: ((Int) -> Void)
    
    /// Init
    /// - Parameters:
    ///   - rating: величина рейтинга / оценка
    ///   - ratingMask: форма для рейтинга (например звезда)
    ///   - ratingElementCount: количество элементов для оценки (по-умолчанию 5)
    ///   - horizontalSpace: горизонтальное расстояние между элементами
    ///   - filledColor: цвет для заполненного элемента
    ///   - notFilledColor: цвет для незаполненного элемента
    ///   - onDidRate: дествие, которое происходит при тапе на элемент рейтинга
    public init(rating: Binding<Double>,
                ratingMask: RatingMask,
                ratingElementCount: Int = 5,
                horizontalSpace: CGFloat = 5,
                filledColor: Color = .red,
                notFilledColor: Color = .gray,
                onDidRate: @escaping ((Int) -> Void) = {_ in}) {
        self._rating = rating
        self.ratingMask = ratingMask
        self.ratingElementCount = ratingElementCount
        self.horizontalSpace = horizontalSpace
        self.filledColor = filledColor
        self.notFilledColor = notFilledColor
        self.onDidRate = onDidRate
    }
    
    public var body: some View {
        HStack(spacing: horizontalSpace) {
            ForEach(0 ..< ratingElementCount) { index in
                RatingElementView(ratingMask: ratingMask,
                                  fillAmount: self.getFillAmount(forIndex: index),
                                  filledColor: filledColor,
                                  notFilledColor: notFilledColor)
                    .onTapGesture(count: 1) {
                        self.didRate(index + 1)
                    }
            }
        }
    }
    
    private func didRate(_ rate: Int) {
        onDidRate(rate)
    }
    
    private func getFillAmount(forIndex index: Int) -> Double {
        let calc = rating - Double(index + 1)
        if calc >= 0.0 {
            return 1.0
        } else if calc <= 0.0 && calc > -1.0 {
            return rating - Double(index)
        } else {
            return 0.0
        }
    }
}
