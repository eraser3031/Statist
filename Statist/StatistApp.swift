//
//  StatistApp.swift
//  Statist
//
//  Created by Kimyaehoon on 04/07/2021.
//

import SwiftUI
import Introspect
// 내일 할 일 .

/*
 1. 타임 테이블 지오메트리에 넣어서 아이패드 호환. -> O
 2. 디자인요소 다시 점검하고 개선하기 -> O
 3. 프로그레스 버튼 클릭 시 기능을 뷰모델로 끌어올릴 방법 찾기 -> O
 4. 프로그레스 버튼 목표치 초과하는 것 개선하기 -> O
 5. 프로그레스 뷰 들어갈 때 overlay 숙주 뷰 크기 조절 버그 수정하기 -> O
 6. 프로그레스 뷰 목표치 도달 시, 타임 테이블이 특정 시간 초과시, 오늘의 투두리스트 전부 완료 시 띄워줄 축하 파티클 뷰 생각하기
 7. 프로그레스 뷰 목표치 도달 시 아이템 뷰 형태 생각하기 -> O
 8. 프로그레스 뷰 갈 때 캘린더 스코프 이슈 -> O
 */

@main
struct StatistApp: App {
    
    var body: some Scene {
        WindowGroup {
            MenuView()
        }
    }
}
