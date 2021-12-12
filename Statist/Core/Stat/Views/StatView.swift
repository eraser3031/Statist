//
//  StatView.swift
//  Statist
//
//  Created by Kimyaehoon on 12/12/2021.
//

import SwiftUI
import OrderedCollections

struct StatView: View {
    
    @StateObject var vm = StatViewModel()
    
    let show: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.vertical, 20)
            
            HStack {
                dateIntervalPicker
                    .compositingGroup()
                
                Spacer()
            }
            .dividerShadow()
            .floatShadow(opacity: 0.1, radius: 10, yOffset: 10)
            .padding(.horizontal, 20)
            .padding(.bottom, 15)
            
            customDivider
                .padding(.vertical, 10)
            
            timeCircleChart
                .padding(.vertical, 10)
            
            Spacer()
        }
    }
}

//  MARK: - UI Components
extension StatView {
    private var header: some View {
        HStack(spacing: 0){
            Text("Stat")
                .scaledFont(name: CustomFont.Gilroy_ExtraBold, size: 25)
                .padding(.vertical, 2)
                .contentShape(Rectangle())
                .onTapGesture{
                    show()
                }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private var dateIntervalPicker: some View {
        HStack(spacing: 0) {
            Button(action: {}) {
                Image(systemName: "chevron.backward")
                    .padding(12)
            }
            
            Label("\(vm.period.start.string()) ~ \(vm.period.end.string())", systemImage: "calendar")
                .minimumScaleFactor(0.1)
                .font(Font.system(.subheadline, design: .default).weight(.medium))
                .padding(.vertical, 10).padding(.horizontal, 12)
                .overlay(Divider(), alignment: .leading)
                .overlay(Divider(), alignment: .trailing)
            
            Button(action: {}) {
                Image(systemName: "chevron.forward")
                    .padding(12)
            }
        }
        .font(Font.system(.subheadline, design: .default).weight(.semibold))
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.theme.backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.theme.dividerColor)
        )
        .accentColor(.primary)
    }
    
    private var customDivider: some View {
        Color.theme.itemBackgroundColor
            .frame(maxWidth: .infinity)
            .frame(height: 10)
    }
    
    private var timeCircleChart: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Invested Time")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            HStack(spacing: 30) {
                circleChart
                    .frame(width: 140, height: 140)
                
                VStack(spacing: 10) {
                    ForEach(vm.circleChartData.keys) { kind in
                        HStack(spacing: 6) {
                            Circle()
                                .foregroundColor(kind.color.primary())
                                .frame(width: 8, height: 8)
                            Text(kind.name ?? "")
                                .font(.headline)
                                .lineLimit(1)
                            Spacer()
                            Text("\( round(vm.calPercent(by: kind)), specifier: "%.0f")%")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var circleChart: some View {
        ZStack {
            GeometryReader { geo in
                
                ForEach(vm.circleChartData.keys.reversed()) { kind in
                    let prevCircleChartData = vm.circleChartData.filter { $0.value > vm.circleChartData[kind, default: 0] }
                    let prevKinds: [KindEntity] = Array(prevCircleChartData.keys)
                    
                    CircleChartSliceView(accmulated: vm.calPercent(by: prevKinds),
                                         now: vm.calPercent(by: kind))
                    .fill(kind.color.primary())
                }
            }
        }
    }
}

struct CircleChartSliceView: Shape {
    var accmulatedPercent: Double
    var percent: Double
    
    init(accmulated accmulatedPercent: Double, now percent: Double) {
        self.accmulatedPercent = accmulatedPercent
        self.percent = percent
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            path.move(to: center)
            path.addArc(center: center,
                        radius: rect.width / 2,
                        startAngle: Angle(degrees: -90.0 + 3.6 * accmulatedPercent),
                        endAngle: Angle(degrees: -90.0 + 3.6 * (accmulatedPercent + percent) ),
                        clockwise: false)
        }
    }
}

struct StatView_Previews: PreviewProvider {
    static var previews: some View {
        StatView(show: {})
    }
}
