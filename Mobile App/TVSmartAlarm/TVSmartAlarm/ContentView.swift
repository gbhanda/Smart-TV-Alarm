//
//  ContentView.swift
//  TVSmartAlarm
//
//  Created by Gokarna Bhandari on 11/8/22.
//

import SwiftUI
import CoreBluetooth



struct ContentView: View {
    @State public var path = NavigationPath()
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("ToledoDarkBlue"), Color("ToledoGolden")]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            //VStack{
                NavigationStack(path: $path){
                    ZStack{
                        Color("ToledoGolden")
                            .edgesIgnoringSafeArea(.all)
                        VStack{
                            Spacer()
                            NavigationLink(value: HomeButtons.registerSignal){
                                HomeButtonView(image: HomeButtons.registerSignal.image, text: HomeButtons.registerSignal.text)
                            }
                            Spacer()
                            NavigationLink(value: HomeButtons.setAlarm){
                                HomeButtonView(image: HomeButtons.setAlarm.image, text: HomeButtons.setAlarm.text)
                            }
                            Spacer()
                            NavigationLink(value: HomeButtons.tV){
                                HomeButtonView(image: HomeButtons.tV.image, text: HomeButtons.tV.text)
                            }
                            Spacer()
                            NavigationLink(value: HomeButtons.test){
                                HomeButtonView(image: HomeButtons.test.image, text: HomeButtons.test.text)
                            }
                            Spacer()
                        }
                        .navigationTitle("Main Menu")
                        .navigationDestination(for: HomeButtons.self) { HomeButton in
                            switch HomeButton{
                            case .registerSignal:
                                RegisterView(title: HomeButton.text, path: $path)
                                .toolbarColorScheme(.dark, for: .navigationBar)
                                .toolbarBackground(Color("ToledoDarkBlue"), for: .navigationBar)
                                .toolbarBackground(.visible, for: .navigationBar)
                            case .setAlarm:
                                AlarmView(title: HomeButton.text, path: $path)
                                .toolbarColorScheme(.dark, for: .navigationBar)
                                .toolbarBackground(Color("ToledoDarkBlue"), for: .navigationBar)
                                .toolbarBackground(.visible, for: .navigationBar)
                            case .tV:
                                TVView(title: HomeButton.text, path: $path)
                                    .toolbarColorScheme(.dark, for: .navigationBar)
                                    .toolbarBackground(Color("ToledoDarkBlue"), for: .navigationBar)
                                    .toolbarBackground(.visible, for: .navigationBar)
                            case .test:
                                TestView(title: HomeButton.text, path: $path)
                                    .toolbarColorScheme(.dark, for: .navigationBar)
                                    .toolbarBackground(Color("ToledoDarkBlue"), for: .navigationBar)
                                    .toolbarBackground(.visible, for: .navigationBar)
                            }
                            //HomeButton.view
                            
                        }                            
                        .toolbarColorScheme(.dark, for: .navigationBar)
                            .toolbarBackground(Color("ToledoDarkBlue"), for: .navigationBar)
                            .toolbarBackground(.visible, for: .navigationBar)
                    }                        
                }
                .foregroundColor(Color.white)
        }
        .background(Color("ToledoGolden"))
    }
    
//    func goToRoot(){
//        $path = 
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView()
        //SelectTVView()
        //RemoteView()
        //RegisterView(title: "Register TV")
        //NewAlarmView()
        //NewButtonRegisteringView()
        //NewTVRegisteringView()
        //ButtonListView()
        //AlarmView(title: "Google")
        //RepeatAlarmView()
        //ListOfSequenceView()
        //TVView(title: "Register TV")
        //SelectButtonSequenceView()
        //EditButtonView(TVID: 0, buttonName: "Power")
        //TestView(title: "Hello")
        iconView()
    }
}

struct iconView: View{
    var body: some View{
        ZStack{
            Color("ToledoGolden")
            Image(systemName: "tv.fill")
                .foregroundColor(Color("ToledoDarkBlue"))
                .font(Font.system(size: 200, weight: .semibold))
            Image(systemName: "av.remote.fill")
                .foregroundColor(.white)
                .font(Font.system(size: 100, weight: .semibold))
        }
    }
}

struct PopUpWindow: View {
    var title: String
    var message: String
    var buttonText: String
    @Binding var show: Bool
    var body: some View {
        ZStack {
            if show {
                // PopUp background color
                Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
                // PopUp Window
                VStack(alignment: .center, spacing: 0) {
                    Text(title)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45, alignment: .center)
                        .font(Font.system(size: 23, weight: .semibold))
                        .foregroundColor(Color.white)
                        .background(Color(#colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)))
                    Text(message)
                        .multilineTextAlignment(.center)
                        .font(Font.system(size: 16, weight: .semibold))
                        .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
                        .foregroundColor(Color.white)
                    Button(action: {
                        // Dismiss the PopUp
                        withAnimation(.linear(duration: 0.3)) {
                            show = false
                        }
                    }, label: {
                        Text(buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54, alignment: .center)
                            .foregroundColor(Color.white)
                            .background(Color(#colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)))
                            .font(Font.system(size: 23, weight: .semibold))
                    }).buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: 300)
                .border(Color.white, width: 2)
                .background(Color(#colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)))
            }
        }
    }
}
