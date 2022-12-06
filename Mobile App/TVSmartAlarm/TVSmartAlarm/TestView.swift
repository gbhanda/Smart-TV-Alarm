//
//  TestView.swift
//  TVSmartAlarm
//
//  Created by Gokarna Bhandari on 11/29/22.
//

import SwiftUI

struct TestView: View{
    var title: String
    @Binding var path: NavigationPath
    var body: some View{
        ZStack{
            Color("ToledoGolden")
            ScrollView{
                RemoteView()
                .background(Color("ToledoGolden"))
                .foregroundColor(.accentColor)
                .navigationTitle(title)
            }
        }
    }
}

struct RemoteView: View{
    var TVList = getTVList()
    var arrayOfButtonInRemote: Array<String> = [
        "Power",
        "Mute",
        "Channel Up",
        "Channel Down",
        "Volume Up",
        "Volume Down",
        "Menu",
        "Input",
        "Exit",
        "Home",
        "Back",
        "Up",
        "Down",
        "Left",
        "Right",
        "OK",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "0"
    ]
    var body: some View{
        ZStack{
            Color("ToledoGolden")
                .edgesIgnoringSafeArea(.all)
            VStack{
                VStack{
                    HStack{
                        Image(systemName: "power.circle.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Power"))
                            }
                        Spacer()
                        Image(systemName: "speaker.slash.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Mute"))
                            }
                    }
                    .font(.system(size:25, design: .default))
                    .frame(width: 330, height: 25, alignment: .center)
                    .padding(.bottom, 5)
                    //.padding(30)
                    HStack{
                        Image(systemName: "plus.app.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Channel Up"))
                            }
                        Spacer()
                        Text("MENU")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Menu"))
                            }
                            .font(.system(size:25, weight: .bold))
                        Spacer()
                        Image(systemName: "speaker.plus.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Volume Up"))
                            }
                    }
                    .font(.system(size:25, design: .default))
                    .frame(width: 270, height: 25, alignment: .center)
                    .padding(.bottom, 5)
                    //.padding(50)
                    HStack{
                        Text("Channel")
                            .foregroundColor(.white)
                        Spacer()
                        Text("Volume")
                            .foregroundColor(.white)
                    }
                    .font(.system(size:20, design: .default))
                    .frame(width: 300, height: 20, alignment: .center)
                    .padding(.bottom, 5)
                    //.padding(30)
                    HStack{
                        Image(systemName: "minus.square.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Channel Down"))
                            }
                        Spacer()
                        Text("INPUT")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Input"))
                            }
                            .font(.system(size:25, weight: .bold))
                        Spacer()
                        Image(systemName: "speaker.minus.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Volume Down"))
                            }
                    }
                    .font(.system(size:25, design: .default))
                    .frame(width: 270, height: 25, alignment: .center)
                    .padding(.bottom, 5)
                    //.padding(40)
                    HStack{
                        Text("EXIT")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Exit"))
                            }
                        Spacer()
                        Image(systemName: "house.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Home"))
                            }
                            .font(.system(size:40, weight:.bold, design: .default))
                        Spacer()
                        Text("BACK")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Back"))
                            }
                    }
                    .font(.system(size:25, weight:.bold, design: .default))
                    .frame(width: 300, height: 40, alignment: .center)
                    .padding(.bottom, 30)
                    //.padding(30)
                    HStack{
                        Image(systemName: "arrowtriangle.backward.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Left"))
                            }
                        Spacer(minLength: 5)
                        VStack{
                            Image(systemName: "arrowtriangle.up.fill")
                                .onTapGesture{
                                    pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Up"))
                                }
                            Spacer(minLength: 5)
                            Image(systemName: "button.programmable")
                                .onTapGesture{
                                    pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "OK"))
                                }
                                .font(.system(size:60, weight:.bold, design: .default))
                            Spacer(minLength: 5)
                            Image(systemName: "arrowtriangle.down.fill")
                                .onTapGesture{
                                    pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Down"))
                                }
                        }
                        Spacer(minLength: 5)
                        Image(systemName: "arrowtriangle.forward.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "Right"))
                            }
                    }
                    .font(.system(size:40, design: .default))
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding(.bottom, 30)
                    HStack{
                        Image(systemName: "1.square.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "1"))
                            }
                        Spacer(minLength: 50)
                        Image(systemName: "2.square.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "2"))
                            }
                        Spacer(minLength: 50)
                        Image(systemName: "3.square.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "3"))
                            }
                    }
                    .font(.system(size:30, design: .default))
                    .frame(width: 30, height: 30, alignment: .center)
                    .padding(.bottom, 10)
                    HStack{
                        Image(systemName: "4.square.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "4"))
                            }
                        Spacer(minLength: 50)
                        Image(systemName: "5.square.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "5"))
                            }
                        Spacer(minLength: 50)
                        Image(systemName: "6.square.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "6"))
                            }
                    }
                    .font(.system(size:30, design: .default))
                    .frame(width: 30, height: 30, alignment: .center)
                    .padding(.bottom, 10)
                    HStack{
                        Image(systemName: "7.square.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "7"))
                            }
                        Spacer(minLength: 50)
                        Image(systemName: "8.square.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "8"))
                            }
                        Spacer(minLength: 50)
                        Image(systemName: "9.square.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "9"))
                            }
                    }
                    .font(.system(size:30, design: .default))
                    .frame(width: 30, height: 30, alignment: .center)
                    .padding(.bottom, 10)
                    HStack{
                        Image(systemName: "0.square.fill")
                            .onTapGesture{
                                pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: "0"))
                            }
                    }
                    .font(.system(size:30, design: .default))
                    .frame(width: 30, height: 30, alignment: .center)
                    .padding(.bottom, 10)
                }
                .frame(minWidth: 100,  maxWidth: 600, minHeight: 540, maxHeight: 700, alignment: .top)
                .foregroundColor(Color("ToledoDarkBlue"))
                .padding(.top, 10)
                //.edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: .infinity))], spacing: 20){
                        ForEach(getButtonList(TVID: currentTVID), id: \.buttonName){button in
                            if !arrayOfButtonInRemote.contains(button.buttonName){
                                Text("\(button.buttonName)")
                                    .onTapGesture{
                                        pressButton(TVID: currentTVID, pressedButton: getButton(TVID: currentTVID, buttonName: button.buttonName))
                                    }
                                    .font(.system(size:20, weight:.bold, design: .default))
                                    .background(Color("ToledoDarkBlue"))
                                    .foregroundColor(.white)
                                    .frame(width: .infinity, height: 30, alignment: .center)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
            }
        }
    }
}
