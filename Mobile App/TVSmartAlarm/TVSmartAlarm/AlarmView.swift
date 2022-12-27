//
//  AlarmView.swift
//  TVSmartAlarm
//
//  Created by Gokarna Bhandari on 11/29/22.
//

import SwiftUI

struct AlarmView: View{
    @Environment(\.presentationMode) var presentation
    var title: String
    @State var alarms: Array<Alarm> = getListOfAlarms(TVID: currentTVID)
    @Binding var path: NavigationPath
    var body: some View{
        ScrollView{
            HStack{
                Spacer()
                NavigationLink(
                    destination: {NewAlarmView(path: $path)},
                    label: {
                        Image(systemName: "plus")
                            .font(.system(size: 25))
                            .padding(.trailing, 10)
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                    }
                )
            }
            ForEach($alarms, id: \.dateTime){ $alarm in
                    HStack{
                        Spacer()
                        Toggle("\(alarm.dateTime, format: .dateTime)", isOn: $alarm.enabled)
                            .onChange(of: alarm.enabled){ newValue in
                                toggleAlarm(TVID: currentTVID, alarmToChange: alarm)
                            }
                            .tint(Color("ToledoDarkBlue"))
                        Image(systemName: "trash.fill")
                            .onTapGesture {
                                deleteAlarmInternal(alarmToDelete: alarm)
                            }
                            .font(.system(size:25, design: .default))
                            .padding(.trailing, 5)
                        NavigationLink(
                            destination: {EditAlarmView(alarm: alarm, alarmCopy: alarm, path: $path)},
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
            }
        }
        .background(.white)
        .foregroundColor(.accentColor)
        .navigationTitle(title)
    }
    func deleteAlarmInternal(alarmToDelete: Alarm){
        deleteAlarm(TVID: currentTVID, alarmToDelete: alarmToDelete)
        path = NavigationPath()
    }
}

enum alarmViewType{
    case main
    case repeatSelector
}

struct NewAlarmView: View{
    //@Environment(\.presentationMode) var presentation
    @State var repeatType: alarmRepeat = alarmRepeat.none
    @State var viewType: alarmViewType = alarmViewType.main
    @State var date = Date()
    @Binding var path: NavigationPath
    var body: some View{
        VStack{
            if viewType == alarmViewType.repeatSelector{
                ZStack{
                    Color("ToledoGolden")
                        .ignoresSafeArea(.all)
                    VStack{
                        Spacer()
                        Picker("Repeat Frequency", selection: $repeatType){
                            ForEach(alarmRepeat.allCases, id: \.self){ alarmRepeatType in
                                Text(alarmRepeatType.text)
                                    .foregroundColor(Color(.white))
                                    .font(.system(size: 25, weight: .bold, design: .default))
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .background(Color("ToledoDarkBlue"))
                        Button("Select"){
                            changeView()
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
            else{
                HStack{
                    Text("Repeat:")
                    Spacer()
                    Text("\(repeatType.text)")
                        .opacity(0.3)
                        .onTapGesture{
                            changeView()
                        }
                }
                //Toggle("Repeat", isOn: $repeatAlarm)
                    .padding(10)
                    .tint(Color("ToledoDarkBlue"))
                    .font(.system(size:18, weight: .bold, design: .default))
                    .background(Color("ToledoGolden"))
                    .foregroundColor(Color("ToledoDarkBlue"))
                Spacer()
                DatePicker(
                    "",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .frame(width: 230, height: 50, alignment: .center)
                .datePickerStyle(.compact)
                .font(.system(size:28, weight: .bold, design: .default))
                .foregroundColor(Color("ToledoDarkBlue"))
                .background(Color("ToledoGolden"))
                .cornerRadius(10)
                Button("Save"){
                    saveAlarmInternal()
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
    
    func changeView(){
        if viewType == alarmViewType.repeatSelector{
            viewType = alarmViewType.main
        }
        else{
            viewType = alarmViewType.repeatSelector
        }
    }
    
    func saveAlarmInternal(){
        saveAlarm(TVID: currentTVID, newAlarm: Alarm(dateTime: date, repeatFrequency: repeatType, enabled: true))
        path = NavigationPath()
    }
}

struct EditAlarmView: View{
    @Environment(\.presentationMode) var presentation
    @State var alarm: Alarm
    var alarmCopy: Alarm
    @State var viewType: alarmViewType = alarmViewType.main
    @Binding var path: NavigationPath
    var body: some View{
        VStack{
            if viewType == alarmViewType.repeatSelector{
                ZStack{
                    Color("ToledoGolden")
                        .ignoresSafeArea(.all)
                    VStack{
                        Spacer()
                        Picker("Repeat Frequency", selection: $alarm.repeatFrequency){
                            ForEach(alarmRepeat.allCases, id: \.self){ alarmRepeatType in
                                Text(alarmRepeatType.text)
                                    .foregroundColor(Color(.white))
                                    .font(.system(size: 25, weight: .bold, design: .default))
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .background(Color("ToledoDarkBlue"))
                        Button("Select"){
                            changeView()
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
            else{
                HStack{
                    Text("Repeat:")
                    Spacer()
                    Text("\(alarm.repeatFrequency.text)")
                        .opacity(0.3)
                        .onTapGesture{
                            changeView()
                        }
                }
                //Toggle("Repeat", isOn: $repeatAlarm)
                    .padding(10)
                    .tint(Color("ToledoDarkBlue"))
                    .font(.system(size:18, weight: .bold, design: .default))
                    .background(Color("ToledoGolden"))
                    .foregroundColor(Color("ToledoDarkBlue"))
                Spacer()
                DatePicker(
                    "",
                    selection: $alarm.dateTime,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .frame(width: 230, height: 50, alignment: .center)
                .datePickerStyle(.compact)
                .font(.system(size:28, weight: .bold, design: .default))
                .foregroundColor(Color("ToledoDarkBlue"))
                .background(Color("ToledoGolden"))
                .cornerRadius(10)
                Button("Save"){
                    editAlarmInternal()
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
    
    func changeView(){
        if viewType == alarmViewType.repeatSelector{
            viewType = alarmViewType.main
        }
        else{
            viewType = alarmViewType.repeatSelector
        }
    }
    
    func editAlarmInternal(){
        editAlarm(TVID: currentTVID, oldAlarm: alarmCopy, newAlarm: alarm)
        //self.presentation.wrappedValue.dismiss()
        path = NavigationPath()
    }
}

struct RepeatAlarmView: View{
    @State var repeatType: alarmRepeat = alarmRepeat.none
    @Binding var path: NavigationPath
    var body: some View{
        ZStack{
            Color("ToledoGolden")
                .ignoresSafeArea(.all)
            VStack{
                Spacer()
                Picker("Repeat Frequency", selection: $repeatType){
                    Text(alarmRepeat.none.text)
                        .foregroundColor(Color(.white))
                        .font(.system(size: 25, weight: .bold, design: .default))
                    Text(alarmRepeat.daily.text)
                        .foregroundColor(Color(.white))
                        .font(.system(size: 25, weight: .bold, design: .default))
                    Text(alarmRepeat.weekly.text)
                        .foregroundColor(Color(.white))
                        .font(.system(size: 25, weight: .bold, design: .default))
                    Text(alarmRepeat.monthly.text)
                        .foregroundColor(Color(.white))
                        .font(.system(size: 25, weight: .bold, design: .default))
                    Text(alarmRepeat.yearly.text)
                        .foregroundColor(Color(.white))
                        .font(.system(size: 25, weight: .bold, design: .default))
                }
                .pickerStyle(WheelPickerStyle())
                .background(Color("ToledoDarkBlue"))
                Button("Save"){
                    
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
}
