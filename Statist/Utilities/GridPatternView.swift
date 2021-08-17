//
//  GridPatternView.swift
//  Statist
//
//  Created by Kimyaehoon on 16/08/2021.
//

import SwiftUI

struct GridPatternView : View {
    
    var spacing: CGFloat = 24

    var body: some View {
        GeometryReader { geo in
            Path { path in
                let numberOfHorizontalGridLines = Int(geo.size.height / self.spacing)
                let numberOfVerticalGridLines = Int(geo.size.width / self.spacing)
                for index in 0...numberOfVerticalGridLines {
                    let vOffset: CGFloat = CGFloat(index) * self.spacing
                    path.move(to: CGPoint(x: vOffset, y: 0))
                    path.addLine(to: CGPoint(x: vOffset, y: geo.size.height))
                }
                for index in 0...numberOfHorizontalGridLines {
                    let hOffset: CGFloat = CGFloat(index) * self.spacing
                    path.move(to: CGPoint(x: 0, y: hOffset))
                    path.addLine(to: CGPoint(x: geo.size.width, y: hOffset))
                }
            }
            .stroke(Color.primary.opacity(0.03))
        }.ignoresSafeArea()
        .background(
            Color.theme.groupBackgroundColor
                .ignoresSafeArea()
        )
        .overlay(
            NoiseOverlayView()
        )
    }
}

struct NoiseOverlayView: View {
    var body: some View {
        GeometryReader { geo in
            Image("NoisePatternForIPhone")
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .blendMode(.overlay)
        }.ignoresSafeArea()
    }
}

struct GridPatternView_Previews: PreviewProvider {
    static var previews: some View {
        GridPatternView()
    }
}
