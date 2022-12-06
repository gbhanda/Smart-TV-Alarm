//
//  HomePage.swift
//  TVSmartAlarm
//
//  Created by Gokarna Bhandari on 11/19/22.
//

import SwiftUI
enum HomeButtons: Int, Hashable, CaseIterable{
    case registerSignal = 1
    case setAlarm = 2
    case tV = 3
    case test = 4
    
    var image: String{
        switch self{
        case .registerSignal:
            return "wave.3.backward"
        case .setAlarm:
            return "alarm.fill"
        case .tV:
            return "tv.fill"
        case .test:
            return "av.remote.fill"
        }
    }
    var text: String{
        switch self{
        case .registerSignal:
            return "Register Signal for TV"
        case .setAlarm:
            return "Set up Alarm"
        case .tV:
            return "TV and Sequences"
        case .test:
            return "Test Device"
        }
    }
    
//    @ViewBuilder
//    var view: some View {
//        switch self{
//        case .registerSignal:
//            RegisterView(title: self.text)
//        case .setAlarm:
//            AlarmView(title: self.text)
//        case .tV:
//            TVView(title: self.text)
//        case .test:
//            TestView(title: self.text)
//        }
//    }
}
extension HomeButtons: Identifiable {
    var id: Int { self.rawValue }
}
struct HomeButtonView: View{
    var image: String
    var text: String
    var body: some View{
        VStack{
            Image(systemName: image)
            Text(text)
        }
        .frame(width: 280, height: 70)
        .foregroundColor(.white)
        .background(Color("ToledoDarkBlue"))
        .font(.system(size:20, weight: .bold, design: .default))
        .cornerRadius(10.0)    }
}
