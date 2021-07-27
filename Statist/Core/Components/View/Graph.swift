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
        let points = entity.getProgressPoints()
        let calendar = Calendar.current
        var data: [Double] = []
        
        for (index, _) in points.enumerated() {
            if points.count == 1 {
                data.append(Double(points.first!.count))
                break
            }
            
            if index == points.count-1 {
                data.append(Double(points[index].count))
                break
            }
            
            let now = points[index].date ?? Date().toDay
            let next = points[index+1].date ?? Date().toDay
            let duration = calendar.dateComponents([.day], from: now, to: next).day ?? 0
            
            for _ in 0...duration {
                data.append(Double(points[index].count))
            }
        }
        
        self.data = data
        self.maxY = Double(entity.goal)
        self.minY = 0
        self.lineColor = entity.kindEntity?.color.toPrimary() ?? Color.primary
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(graphBackground)
                .overlay(graphYAxis.padding(.horizontal, 4), alignment: .leading)
        }
        .font(.caption)
        .foregroundColor(.theme.groupBackgroundColor)
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
                    let yAxis = maxY - minY
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
    
    private var graphYAxis: some View {
        VStack{
            Text("\(Int(maxY))")
            Spacer()
            Text("\(Int((minY + maxY) / 2))")
            Spacer()
            Text("\(Int(minY))")
        }
    }
}
