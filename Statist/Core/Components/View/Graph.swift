//
//  Graph.swift
//  Statist
//
//  Created by Kimyaehoon on 25/07/2021.
//

import SwiftUI

struct Graph: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    @State private var percentage: CGFloat = 0
    
    init(entity: ProgressEntity){
        let data: [ProgressPoint] = entity.progressPoints?.allObjects as? [ProgressPoint] ?? []
    }
    
    var body: some View {
        chartView
            .background(
                graphBackground
            )
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.linear(duration: 1.5)) {
                        percentage = 1.0
                    }
                }
            }
    }
}

extension Graph {
    private var chartView: some View {
        GeometryReader { geo in
            Path { path in
                for index in data.indices {
                    let xPosition = geo.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    let yAxis = maxY - minY // maxY 와 minY는 무엇을 뜻하는가?
                    let yPosition = (1-CGFloat((data[index] - minY) / yAxis)) * geo.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
    
    private var graphBackground: some View {
        VStack(spacing: 0){
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
}
