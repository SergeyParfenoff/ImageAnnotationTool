//
//  ColorManager.swift
//  ImageAnnotationTool
//
//  Created by Sergey on 05.05.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import SwiftUI

final class LabelColorManager {
    
    private var baseColors = [ 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0, 0xbf0199 ]
    private var usedColors = [Color]()
    
    func getColor () -> Color {
        var resultColor: Color
        
        if !baseColors.isEmpty {
            resultColor = сolorFromHex(rgbValue: baseColors.removeLast())
        } else {
            resultColor = randomColor()
        }
        usedColors.append(resultColor)
        
        return resultColor
    }
    
    private func randomColor()  -> Color {
        var resultColor: Color
        var attemptsCounter = 3
        
        repeat {
            resultColor = Color(red: Double.random(in: 0...1),
                                green: Double.random(in: 0...1),
                                blue: Double.random(in: 0...1))
            attemptsCounter -= 1
        } while usedColors.firstIndex(of: resultColor) != nil && attemptsCounter > 0
        
        return resultColor
    }
    
    private func сolorFromHex(rgbValue: Int) -> Color {
        let red =   Double((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = Double((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue =  Double(rgbValue & 0x0000FF) / 0xFF
        
        return Color(red: red, green: green, blue: blue)
    }
}

