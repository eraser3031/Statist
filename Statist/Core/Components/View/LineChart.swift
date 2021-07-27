//
//  LineChart.swift
//  Statist
//
//  Created by Kimyaehoon on 25/07/2021.
//

import SwiftUI

struct LineChart: View {
    
    let datas: [[TimetableEntity]]
    
    init(datas: [[TimetableEntity]]) {
        self.datas = datas
    }
    
    var body: some View {
        chartView
            .background(chartBackground)
            .overlay(graphYAxis)
    }
}

extension LineChart {
    private var chartView: some View {
        GeometryReader { geo in
            HStack{
                ForEach(0..<datas.count) { index in
                    VStack(spacing: 0){
                        ForEach(datas[index]) { data in
                            Rectangle()
                                .fill(data.kindEntity?.color.toPrimary() ?? Color.primary)
                                .frame(width: 8,
                                       height: geo.size.height * CGFloat(data.duration ) / calTotalMin(datas[index]) )
                        }
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                    )
                }
            }
        }
    }
    
    private var chartBackground: some View {
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
//            Text("\(Int(maxY))")
//            Spacer()
//            Text("\(Int((minY + maxY) / 2))")
//            Spacer()
//            Text("\(Int(minY))")
        }
    }
    
    private func calTotalMin(_ entitys: [TimetableEntity]) -> CGFloat {
        return entitys.reduce(0) { result, entity in
            return result + CGFloat(entity.duration)
        }
    }
}

//struct LineChart_Previews: PreviewProvider {
//    static *ar previews: some View {
//        LineChart()
//    }
