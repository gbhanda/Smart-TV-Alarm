//
//  RegisterView.swift
//  TVSmartAlarm
//
//  Created by Gokarna Bhandari on 11/29/22.
//

import SwiftUI

struct RegisterView: View{
    var title: String
    @Binding var path: NavigationPath
    var body: some View{
        ZStack{
            Color("ToledoGolden")
            VStack{
                HStack{
                    Text("List of TVs")
                        .foregroundColor(Color("ToledoDarkBlue"))
                        .font(.system(size: 25, weight: .bold))
                }
                ScrollView{
                    Spacer()
                    ForEach(getTVList(), id: \.TVID){ TV in
                        //NavigationLink(value: TV.TVID){
                            HStack{
                                Spacer()
                                Text(TV.name)
                                    .font(.system(size:12, weight: .bold, design: .default))
                                Spacer()
                                NavigationLink(
                                    destination: {
                                        ButtonListView(TVID: TV.TVID, path: $path)
                                        .toolbarColorScheme(.dark, for: .navigationBar)
                                        .toolbarBackground(Color("ToledoDarkBlue"), for: .navigationBar)
                                        .toolbarBackground(.visible, for: .navigationBar)
                                    },
                                    label: {
                                        Image(systemName: "slider.horizontal.3")
                                            .font(.system(size:25, design: .default))
                                    }
                                    )
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .foregroundColor(Color("ToledoDarkBlue"))
                            .background(Color("ToledoGolden"))
                            .border(Color("ToledoDarkBlue"))
                            .cornerRadius(5.0)
                            //.cornerRadius(7.0)
                        //}
                    }
                }
                .background(.white)
                .foregroundColor(.accentColor)
                .navigationTitle(title)
            }
        }
        
    }
}

struct NewButtonRegisteringView: View{
    var TVID: Int
    @State private var buttonName: String = ""
    @State var buttonSignal: Array<UInt16> = []
    @State var status: String = "No Signal Detected"
    @Binding var path: NavigationPath
    var body: some View{
        ZStack{
            Color("ToledoGolden")
                .ignoresSafeArea(.all)
            VStack{
                HStack{
                    Text("Status:")
                    Text("\(status)")
                        .foregroundColor(Color("ToledoDarkBlue"))
                }
                Text("Register Button")
                    .foregroundColor(Color("ToledoDarkBlue"))
                    .padding(.bottom, 20)
                    .font(.system(size: 40, weight: .bold, design: .default))
                TextField("", text: $buttonName)
                    .placeholder(when: buttonName.isEmpty) {
                            Text("Button Name")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 300, height: 40, alignment: .center)
                    .background(Color("ToledoDarkBlue"))
                    .accentColor(.white)
                    .border(Color("ToledoDarkBlue"))
                    .cornerRadius(10)
                    .padding(.bottom, 30)
                Button(action: {
                    setSignal()
                }) {
                    Text("Detect Signal")
                        .frame(width: 200, height: 200, alignment: .center)
                        .background(Color("ToledoDarkBlue"))
                        .cornerRadius(10)
                        .padding(.bottom, 30)
                }
                Button("Save"){
                    saveButtonInternal()
                }
                .frame(width: 80, height: 40, alignment: .center)
                .background(Color("ToledoDarkBlue"))
                .cornerRadius(10)
            }
            .font(.system(size: 20, weight: .bold, design: .default))
            .foregroundColor(.white)
        }
    }
    func setSignal(){
        buttonSignal = detectSignal()
        if buttonSignal != [] {
            status = "Signal Registered"
        }
        else{
            status = "Unable to Detect Signal"
        }
    }
    func saveButtonInternal(){
        status = saveButton(TVID: TVID, ButtonName: buttonName, Signal: buttonSignal)
        path = NavigationPath()
    }
}

struct EditButtonView: View{
    var TVID: Int
    var duplicateButtonName: String
    @State var buttonName: String
    @State var buttonSignal: Array<UInt16>
    @State var status: String = "No Signal Detected"
    @Binding var path: NavigationPath
    var body: some View{
        ZStack{
            Color("ToledoGolden")
                .ignoresSafeArea(.all)
            VStack{
                HStack{
                    Text("Status:")
                    Text("\(status)")
                        .foregroundColor(Color("ToledoDarkBlue"))
                }
                Text("Edit Button")
                    .foregroundColor(Color("ToledoDarkBlue"))
                    .padding(.bottom, 20)
                    .font(.system(size: 40, weight: .bold, design: .default))
                TextField("", text: $buttonName)
                    .placeholder(when: buttonName.isEmpty) {
                            Text("Button Name")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 300, height: 40, alignment: .center)
                    .background(Color("ToledoDarkBlue"))
                    .accentColor(.white)
                    .border(Color("ToledoDarkBlue"))
                    .cornerRadius(10)
                    .padding(.bottom, 30)
                Button(action: {
                    setSignal()
                }) {
                    Text("Detect Signal")
                        .frame(width: 200, height: 200, alignment: .center)
                        .background(Color("ToledoDarkBlue"))
                        .cornerRadius(10)
                        .padding(.bottom, 30)
                }
                
//                NavigationLink(
//                    destination: ContentView(),
//                    label: {
                Button("Save"){
                        editButtonInternal()
                    }
                .frame(width: 80, height: 40, alignment: .center)
                .background(Color("ToledoDarkBlue"))
                .cornerRadius(10)
//                    }
//                )
                
            }
            .font(.system(size: 20, weight: .bold, design: .default))
            .foregroundColor(.white)
        }
    }
    func editButtonInternal(){
        status = editButton(TVID: TVID, ButtonName: duplicateButtonName, newButtonName: buttonName, newSignal: buttonSignal)
        path = NavigationPath()
    }
    func setSignal(){
        buttonSignal = detectSignal()
        if buttonSignal != [] {
            status = "Signal Registered"
        }
        else{
            status = "Unable to Detect Signal"
        }
    }
}

struct ButtonListView: View{
    var TVID: Int
    @Binding var path: NavigationPath
    var body: some View{
        ZStack{
            Color("ToledoGolden")
                .ignoresSafeArea(.all)
            VStack{
                Text("\(getTV(TVID: TVID).name)")
                    .frame(width: .infinity, height: 40, alignment: .center)
                    .background(Color("ToledoDarkBlue"))
                    .cornerRadius(10)
                    .padding(.top, 10)
                HStack{
                    Spacer()
                    NavigationLink(
                        destination: {
                            NewButtonRegisteringView(TVID: TVID, path: $path)
                        },
                        label: {
                            Image(systemName: "plus")
                                .font(.system(size: 25))
                                .padding(.trailing, 10)
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                        }
                    )
                    
                }
                ScrollView{
                    Spacer()
                    ForEach(getTV(TVID: TVID).arrayOfButtons, id: \.buttonName){ button in
                        NavigationLink(
                            destination: {
                                EditButtonView(TVID: TVID, duplicateButtonName: button.buttonName, buttonName: button.buttonName, buttonSignal: button.signal, path: $path)
                                    .toolbarColorScheme(.dark, for: .navigationBar)
                                    .toolbarBackground(Color("ToledoDarkBlue"), for: .navigationBar)
                                    .toolbarBackground(.visible, for: .navigationBar)
                            },
                            label: {
                                HStack{
                                    Spacer()
                                    Text("\(button.buttonName)")
                                        .font(.system(size:25, weight: .bold, design: .default))
                                    Spacer()
                                    //.padding(.trailing, 5)
                                    //Image(systemName: "trash.fill")
                                    //.font(.system(size:25, design: .default))
                                    //Image(systemName: "slider.horizontal.3")
                                    //.font(.system(size:25, design: .default))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 40, alignment: .center)
                                .foregroundColor(Color("ToledoDarkBlue"))
                                .background(Color("ToledoGolden"))
                                .border(Color("ToledoDarkBlue"))
                                .cornerRadius(5.0)
                            })
                        
                    }
                }
                .background(.white)
            }
            .foregroundColor(.white)
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension String {
    init(utf32chars:[UInt32?]) {
        let data = Data(bytes: utf32chars, count: utf32chars.count * MemoryLayout<UInt32>.stride)
        self = String(data: data, encoding: .utf32LittleEndian)!
    }
}

struct Previews_RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
