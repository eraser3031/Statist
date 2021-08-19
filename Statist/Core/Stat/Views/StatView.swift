////
////  StatView.swift
////  Statist
////
////  Created by Kimyaehoon on 25/07/2021.
////
//
//import SwiftUI
//
//struct StatView: View {
//    @StateObject var vm = StatViewModel()
//    
//    var body: some View {
//        VStack(alignment: .leading){
//            Text("Stat")
//                .font(.largeTitle)
//                .fontWeight(.heavy)
//            
//            ScrollView(.vertical, showsIndicators: false) {
//                LineChart(datas: vm.timetableEntityGroups)
//                    .frame(height: 300)
//                
//                VStack{
//                    ForEach(vm.result) { entity in
//                        Text(entity.date ?? Date().toDay, style: .date)
//                    }
//                }
//                
////                AchievementView()
//                
//                PeriodView()
//                
//                PercentageView()
//                
//                ProgressGraphView()
//            }
//        }
//        .padding(.horizontal, 20)
//    }
//}
//
//struct StatView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatView()
//    }
//}
