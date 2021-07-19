//
//  SwiftUIView.swift
//  
//
//  Created by Danil Lomaev on 15.07.2021.
//

import SwiftUI

/// View для отрисовки недели, рисует ячейки дней в строчку
struct WeekView<DateView>: View where DateView: View {
    /// Текущий календарь системы
    @Environment(\.calendar) var calendar

    /// Неделя, которую надо отрисовать
    let week: Date
    
    /// Контент календаря
    let content: (Date) -> DateView
    
    /// Init
    /// - Parameters:
    ///   - week: неделя, которую нужно нарисовать
    ///   - content: ячейка дня
    init(
        week: Date,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.week = week
        self.content = content
    }

    private var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week) else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(days, id: \.self) { date in
                HStack(spacing: 0) {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}
