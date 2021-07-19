//
//  SwiftUIView.swift
//  
//
//  Created by Danil Lomaev on 15.07.2021.
//

import SwiftUI

/// View для создания контейнера календаря
public struct GXCalendarView<DateView>: View where DateView: View {
    /// Текущий календарь системы
    @Environment(\.calendar) var calendar

    /// Интервал даты
    let interval: DateInterval
    
    /// анимация скролла к текущему месяцу
    let scrollAnimation: Animation
    
    /// контент календаря
    let content: (Date) -> DateView
    
    /// Init
    /// - Parameters:
    ///   - interval: Обязательный параметр, определяет диапазон отрисовки календаря
    ///   - scrollAnimation: Необязательный параметр, определяет анимацию скролла к текущему месяцу
    ///   - content: Обязательный параметр, сам контент календаря (ячейка дня)
    public init(
        interval: DateInterval,
        scrollAnimation: Animation = .default,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.interval = interval
        self.scrollAnimation = scrollAnimation
        self.content = content
    }

    private var months: [Date] {
        calendar.generateDates(inside: interval, matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0))
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if #available(iOS 14.0, *) {
                ScrollViewReader { value in
                    VStack {
                        ForEach(months, id: \.self) { month in
                            MonthView(month: month, content: self.content)
                                .id(month)
                        }
                    }
                    .onAppear {
                        withAnimation(scrollAnimation) {
                            value.scrollTo(months[self.calendar.component(.month, from: Date()) - 1])
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
                VStack {
                    ForEach(months, id: \.self) { month in
                        MonthView(month: month, content: self.content)
                            .id(month)
                    }
                }
            }
        }
    }
}
