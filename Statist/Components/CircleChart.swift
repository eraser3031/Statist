////
////  CircleChart.swift
////  Statist
////
////  Created by Kimyaehoon on 25/07/2021.
////
//
//import SwiftUI
//
//struct CircleChart: View {
//
//    var percent: Double
//    var colors: [Color]
//    var trim: CGFloat
//
//    init(percent: Double, colors: [Color]) {
//        self.percent = percent
//        self.colors = colors
//        self.trim = CGFloat(percent)/100
//    }
//
//    var body: some View {
//        GeometryReader { geo in
//            ZStack {
//                Circle()
//                    .stroke(Color(.quaternaryLabel), lineWidth: geo.size.width/8)
//
//                Circle()
//                    .trim(from: 1-trim, to: 1)
//                    .stroke(
//                        LinearGradient(gradient: Gradient(colors: colors),
//                                       startPoint: .topLeading,
//                                       endPoint: .bottomTrailing)
//                        ,style: StrokeStyle(lineWidth: geo.size.width/8,
//                                            lineCap: .round,
//                                            lineJoin: .round,
//                                            miterLimit: .infinity)
//                    )
//                    .rotationEffect(Angle(degrees: 90))
//                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
//            }
//        }
//    }
//}
//
//struct ChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        CircleChart(percent: 70, colors: [.red])
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}
