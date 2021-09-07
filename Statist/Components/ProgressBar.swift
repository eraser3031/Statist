////
////  ProgressBar.swift
////  Statist
////
////  Created by Kimyaehoon on 20/07/2021.
////
//
//import SwiftUI
//
//struct ProgressBar: View {
//    let now: Int
//    let goal: Int
//    let color: Color?
//
//    init(now: Int, goal: Int, _ color: Color? = Color.primary) {
//        self.now = now
//        self.goal = goal
//        self.color = color
//    }
//
//    var body: some View {
//        GeometryReader { geo in
//            ZStack(alignment: .leading){
//                Capsule(style: .continuous)
//                    .stroke(Color.theme.dividerColor)
//
//                Capsule(style: .continuous)
//                    .fill(color ?? Color.primary)
//                    .frame(width: geo.size.width * CGFloat(now) / CGFloat(goal))
//                    .frame(maxHeight: geo.size.height)
//            }
//            .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
//        }
//    }
//}
//
//struct ProgressBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressBar(now: 4, goal: 10)
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}
