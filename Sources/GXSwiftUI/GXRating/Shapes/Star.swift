//
//  Star.swift
//  Red
//
//  Created by Anton on 03.06.2021.
//

import SwiftUI

/// Структура  описывает форму  звезды для одиночного элемента рейтинга
public struct Star: Shape {
    /// количество лучей звезды
     var sides: Int = 5
    /// определяет выпуклость звездных лучей
     var innerRadiusDivider: CGFloat = 5
    /// описанный радиус звезды делится на эту величину, определяет длину звездных лучей
     var outerRadiusDivider: CGFloat = 2
    
    /// Init
    /// - Parameters:
    ///   - sides: количество лучей звезды, по-умолчанию звезда пятиконечная
    ///   - innerRadiusDivider: определяет выпуклость звездных лучей
    ///   - outerRadiusDivider: описанный радиус звезды делится на эту величину, определяет длину звездных лучей
    public init(sides: Int = 5,
                innerRadiusDivider: CGFloat = 5,
                outerRadiusDivider: CGFloat = 2) {
        self.sides = sides
        self.innerRadiusDivider = innerRadiusDivider
        self.outerRadiusDivider = outerRadiusDivider
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let startAngle = CGFloat(-1 * (360 / sides / 4))
        let adjustment = startAngle + CGFloat(360 / sides / 2)
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let innerPolygon = polygonPointArray(sides: sides,
                                             x: center.x,
                                             y: center.y,
                                             radius: rect.width / innerRadiusDivider,
                                             adjustment: startAngle)
        let outerPolygon = polygonPointArray(sides: sides,
                                             x: center.x,
                                             y: center.y,
                                             radius: rect.width / outerRadiusDivider,
                                             adjustment: adjustment)
        let points = zip(innerPolygon, outerPolygon)
        path.move(to: innerPolygon[0])
        points.forEach { innerPoint, outerPoint in
            path.addLine(to: innerPoint)
            path.addLine(to: outerPoint)
        }
        path.closeSubpath()
        return path
    }
    
    /// Функция переводит градусы в радианы
    /// - Parameter degree: градусы
    /// - Returns: радианы
    private func degree2Radian(_ degree: CGFloat) -> CGFloat {
        return CGFloat.pi * degree / 180
    }
    
    /// Функция возвращает массив точек для построения звезды
    /// - Parameters:
    ///   - sides: количество лучей звезды
    ///   - x: х - координата
    ///   - y: у - координата
    ///   - radius: радиус
    ///   - adjustment: необязательный параметр - смещение в градусах, чтобы повернуть звезду
    /// - Returns: массив точек
    private func polygonPointArray(sides: Int,
                           x: CGFloat,
                           y: CGFloat,
                           radius: CGFloat,
                           adjustment: CGFloat = 0) -> [CGPoint]
    {
        let angle = degree2Radian(360 / CGFloat(sides))
        return Array(0 ... sides).map { side -> CGPoint in
            let adjustedAngle: CGFloat = angle * CGFloat(side) + degree2Radian(adjustment)
            let xpo = x - radius * cos(adjustedAngle)
            let ypo = y - radius * sin(adjustedAngle)
            return CGPoint(x: xpo, y: ypo)
        }
    }
}
