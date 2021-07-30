//
//  RatingElementView.swift
//  swiftui_components
//
//  Created by Anton on 16.07.2021.
//

import SwiftUI

/// Одиночный элемент отображения рейтинга
public struct RatingElementView<RatingMask: Shape>: View {
     var ratingMask: RatingMask
     var fillAmount: Double
     var filledColor: Color
     var notFilledColor: Color

    public var body: some View {
        ZStack {
            Rectangle()
                .fill(notFilledColor)

            GeometryReader { geometry in
                Rectangle()
                    .fill(filledColor)
                    .frame(width: geometry.size.width * CGFloat(fillAmount), height: geometry.size.height, alignment: .leading)
            }
        }
        .mask(ratingMask)
    }
}
