//
//  TVView.swift
//  TVSmartAlarm
//
//  Created by Gokarna Bhandari on 11/29/22.
//

import SwiftUI

struct TVView: View{
    var title: String
    @Binding var path: NavigationPath
    var body: some View{
        ZStack{
            Color("ToledoGolden")
                .ignoresSafeArea(.all)
            VStack{
                HStack{
                    Text("Selected TV: \(getTV().name)")
                        .foregroundColor(Color("ToledoDarkBlue"))
                    Spacer()
                    NavigationLink(
                        destination: {SelectTVView(path: $path)},
                        label: {
                            Text("Select TV")
                                .frame(width: 100, height: 25, alignment: .center)
                                .background(Color("ToledoDarkBlue"))
                                .foregroundColor(.white)
                                .border(Color("ToledoDarkBlue"))
                                .cornerRadius(5)
                        }
                    )
                }
                .padding(5)
                HStack{
                    Text("List of TVs")
                        .foregroundColor(Color("ToledoDarkBlue"))
                        .font(.system(size: 25, weight: .bold))
                    Spacer()
                    NavigationLink(
                        destination: {NewTVRegisteringView(path: $path)},
                        label: {Image(systemName: "plus")
                                .font(.system(size: 25))
                                .padding(.trailing, 10)
                                .padding(.top, 5)
                                .padding(.bottom, 5)})
                    
                }
                ScrollView{
                    Spacer()
                    ForEach(getTVList(), id: \.TVID){ TV in
                        NavigationLink(value: TV.TVID){
                            HStack{
                                Spacer()
                                Text(TV.name)
                                    .font(.system(size:12, weight: .bold, design: .default))
                                Spacer()
                                Image(systemName: "trash.fill")
                                    .onTapGesture{
                                        deleteTVInternal(TVID: TV.TVID)
                                    }
                                    .font(.system(size:25, design: .default))
                                NavigationLink(
                                    destination: {
                                        ListOfSequenceView(TVID: TV.TVID, actionSequences: listSequences(TVID: TV.TVID), path: $path)
                                    },
                                    label: {
                                        Image(systemName: "slider.horizontal.3")
                                            .font(.system(size:25, design: .default))
                                    })                                
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .foregroundColor(Color("ToledoDarkBlue"))
                            .background(Color("ToledoGolden"))
                            .border(Color("ToledoDarkBlue"))
                            .cornerRadius(5.0)
                        }
                    }
                }
                .background(.white)
                .foregroundColor(.accentColor)
                .navigationTitle(title)
            }
        }
        
    }
    func deleteTVInternal(TVID: Int){
        deleteTV(TVID: TVID)
        path = NavigationPath()
    }
}

struct ListOfSequenceView: View{
    var TVID: Int
    var actionSequences: Array<buttonInSequence>
    @Binding var path: NavigationPath
    var body: some View{
        ZStack{
            Color("ToledoGolden")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                Text("Sequence of Actions.")
                    .font(.system(size:20, weight:.bold, design: .default))
                    .frame(width: .infinity, height: 40, alignment: .center)
                    .background(Color("ToledoDarkBlue"))
                    .cornerRadius(10)
                    .padding(.top, 10)
                ScrollView{
                    Spacer()
                    ForEach(actionSequences, id: \.self){ actionSequence in
                        HStack{
                            Text("\(actionSequence.buttonName)")
                            Spacer()
                            Text("\(actionSequence.numOfRepeat)")
                            Image(systemName: "trash.fill")
                                .onTapGesture {
                                    deleteButtonOnSequenceInternal(sequenceID: actionSequence.sequenceID)
                                }
                                .font(.system(size:25, design: .default))
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .font(.system(size:15, weight:.bold, design: .default))
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .foregroundColor(Color("ToledoDarkBlue"))
                        .background(Color("ToledoGolden"))
                        .border(Color("ToledoDarkBlue"))
                        .cornerRadius(5.0)
                    }
                    HStack{
                        Spacer()
                        NavigationLink(
                            destination: {
                                SelectButtonSequenceView(TVID: TVID, button: getButtonList(TVID: TVID)[0], buttons: getButtonList(TVID: TVID), path: $path)
                            },
                            label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 25))
                                    .padding(.trailing, 10)
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                                    .foregroundColor(Color("ToledoDarkBlue"))
                            }
                        )
                    }
                }
                .background(.white)
            }
            .foregroundColor(.white)
        }
    }
    func deleteButtonOnSequenceInternal(sequenceID: Int){
        deleteButtonOnSequence(TVID: TVID, sequenceID: sequenceID)
        path = NavigationPath()
    }
}

struct NewTVRegisteringView: View{
    @State private var tVName: String = ""
    @State private var status: String = "Registering"
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
                TextField("", text: $tVName)
                    .placeholder(when: tVName.isEmpty) {
                            Text("TV Name")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 300, height: 40, alignment: .center)
                    .background(Color("ToledoDarkBlue"))
                    .accentColor(.white)
                    .border(Color("ToledoDarkBlue"))
                    .cornerRadius(10)
                    .padding(.bottom, 30)
                Button("Save"){
                    addTVInternal()             }
                .frame(width: 80, height: 40, alignment: .center)
                .background(Color("ToledoDarkBlue"))
                .cornerRadius(10)
            }
            .font(.system(size: 20, weight: .bold, design: .default))
            .foregroundColor(.white)
        }
    }
    func addTVInternal(){
        if tVName.count <= 30{
            addTV(tVName: tVName)
            path = NavigationPath()
        }
        else{
            status = addTV(tVName: tVName)
        }
    }
}

struct SelectButtonSequenceView: View{
    var TVID: Int
    @State var button: RemoteButton
    @State var frequency: Int = 1
    var buttons: Array<RemoteButton>
    var frequencies: Array<Int> = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    @Binding var path: NavigationPath
    var body: some View{
        ZStack{
            Color("ToledoGolden")
                .ignoresSafeArea(.all)
            VStack{
                Spacer()
                Text("Select Button and Number of times you want to Repeat.")
                    .frame(width: 400, height: 50)
                    .foregroundColor(.white)
                    .background(Color("ToledoDarkBlue"))
                    .cornerRadius(10)
                Spacer()
                HStack{
                    Picker("Button", selection: $button){
                        ForEach(buttons, id: \.self){button in
                            Text(button.buttonName)
                                .foregroundColor(Color(.white))
                                .font(.system(size: 25, weight: .bold, design: .default))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .background(Color("ToledoDarkBlue"))
                    .cornerRadius(10)
                    Spacer()
                    Picker("Repeat Frequency", selection: $frequency){
                        ForEach(frequencies, id: \.self){frequency in
                            Text("\(frequency)")
                                .foregroundColor(Color(.white))
                                .font(.system(size: 25, weight: .bold, design: .default))
                        }
                    }
                    .frame(width:60)
                    .pickerStyle(WheelPickerStyle())
                    .background(Color("ToledoDarkBlue"))
                    .cornerRadius(10)
                }
                Spacer()
                Button("Save"){
                    saveButtonSequence()
                }
                .font(.system(size:28, weight: .bold, design: .default))
                .frame(width: 100, height: 50, alignment: .center)
                .foregroundColor(Color("ToledoGolden"))
                .background(Color("ToledoDarkBlue"))
                .cornerRadius(10)
                Spacer()
            }
        }
    }
    func saveButtonSequence(){
        addButtonInSequence(TVID: TVID, buttonName: button.buttonName, numOfRepeat: frequency)
        path = NavigationPath()
    }
}

struct SelectTVView: View{
    @State var TVs: Array<TV> = getTVList()
    @State var selectedTVID: Int = currentTVID
    @Binding var path: NavigationPath
    var body: some View{
        ZStack{
            Color("ToledoGolden")
                .ignoresSafeArea(.all)
            VStack{
                Picker("TVs", selection: $selectedTVID){
                    ForEach(TVs, id: \.TVID){TV in
                        Text(TV.name)
                            .foregroundColor(Color(.white))
                            .font(.system(size: 25, weight: .bold, design: .default))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .background(Color("ToledoDarkBlue"))
                .cornerRadius(10)
                Button("Save"){
                    selectTVInternal()
                }
                .font(.system(size: 25, weight: .bold))
                .frame(width: 70, height: 40, alignment: .center)
                .foregroundColor(.white)
                .background(Color("ToledoDarkBlue"))
                .cornerRadius(10)
                .padding(.top, 20)
            }
        }
    }
    func selectTVInternal(){
        selectTV(TVID: selectedTVID)
        path = NavigationPath()
    }
}
