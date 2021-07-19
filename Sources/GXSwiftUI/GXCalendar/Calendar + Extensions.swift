//
//  File.swift
//  
//
//  Created by Danil Lomaev on 15.07.2021.
//

import Foundation

extension Calendar {
    /// Узнает диапазон между датам в зависимости от переданного Calendar.Component
    /// - Parameters:
    ///   - from: начальный интервал
    ///   - to: конечный интервал
    ///   - components:  Calendar.Component, который решает в чем считать диапазон (день, месяц, год)
    /// - Returns: Целое число, которое показывает кол-во дней/месяцев/годов
    func periodBetween(_ from: Date, and to: Date, with components: Set<Calendar.Component>) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents(components, from: fromDate, to: toDate)
        switch components {
        case [.day]:
            return numberOfDays.day!
        case [.month]:
            return numberOfDays.month!
        case [.year]:
            return numberOfDays.year!
        default: return 0
        }
    }
}

extension Calendar {
    /// Генерирует какое-то кол-во дат
    /// - Parameters:
    ///   - interval: Интервал генерации
    ///   - components: Компонент, в котором нужно генерировать
    /// - Returns: Массив дат, в котором содержатся, например, все даты текущего месяца
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}
