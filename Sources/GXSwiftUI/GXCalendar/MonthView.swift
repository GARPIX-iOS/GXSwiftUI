//
//  SwiftUIView.swift
//  
//
//  Created by Danil Lomaev on 15.07.2021.
//

import SwiftUI

/// View для отрисовки недель в 1 месяц
struct MonthView<DateView>: View where DateView: View {
    /// Текущий календарь системы
    @Environment(\.calendar) var calendar

    /// Месяц, который нужно отрисовать
    let month: Date
    
    /// Показывать ли заголовок месяца
    let showHeader: Bool
    
    /// Контент месяца
    let content: (Date) -> DateView
    
    /// Init
    /// - Parameters:
    ///   - month: месяц, который нужно отрисовать
    ///   - showHeader: показывать ли заголовок месяца
    ///   - content: ячейка дня, которая передается во WeekView
    init(
        month: Date,
        showHeader: Bool = true,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.content = content
        self.showHeader = showHeader
    }

    private var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }

    private var header: some View {
        let formatter = DateFormatter.monthAndYear
        return Text(formatter.string(from: month).capitalized)
            .autocapitalization(.words)
            .padding()
    }

    var body: some View {
        VStack(spacing: 1) {
            if showHeader {
                header
            }
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
    }
}
