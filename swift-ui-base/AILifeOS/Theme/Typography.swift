//
//  Typography.swift
//  AI Life OS
//

import SwiftUI

enum AppTypography {
    static func largeTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 34, weight: .bold, design: .rounded))
    }
    
    static func title(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 22, weight: .semibold, design: .rounded))
    }
    
    static func headline(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 17, weight: .semibold, design: .rounded))
    }
    
    static func body(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 15, weight: .regular, design: .default))
    }
    
    static func caption(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .medium, design: .rounded))
    }
}
