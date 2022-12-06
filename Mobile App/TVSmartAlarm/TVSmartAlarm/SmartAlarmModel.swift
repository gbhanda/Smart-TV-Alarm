//
//  SmartAlarmModel.swift
//  TVSmartAlarm
//
//  Created by Gokarna Bhandari on 11/16/22.
//

import Foundation

var currentTVID = 0

var buttonSequenceArray: Array<buttonInSequence> = [
    buttonInSequence(sequenceID: 0, buttonName: "Power", numOfRepeat: 1),
    buttonInSequence(sequenceID: 1, buttonName: "Volume Up", numOfRepeat: 15)]

var TVs: Array<TV> = [
    TV(TVID: 0, name: "DefaultRoku", alarms: [Alarm(dateTime: Date(), repeatFrequency: .none, enabled: true)], sequnce: buttonSequenceArray),
    TV(TVID:1, name: "LG"),
    TV(TVID:21, name: "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"),
    ]

struct RemoteButton: Hashable, Equatable{
    var buttonName: String
    var signal: Array<UInt16> = [] // Has 67 element
}

struct buttonInSequence: Hashable{
    var sequenceID: Int
    var buttonName: String
    var numOfRepeat: Int
}

extension Date{
    static func == (lhs: Date, rhs: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd hh:mm"
        return (dateFormatter.string(from: lhs) == dateFormatter.string(from: rhs))
    }
}

struct TV: Hashable{
    static func == (lhs: TV, rhs: TV) -> Bool {
        return lhs.TVID == rhs.TVID
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(TVID)
    }
    
    var TVID: Int
    var name: String
    var arrayOfButtons: Array<RemoteButton> = [
        RemoteButton(buttonName: "Power"),
        RemoteButton(buttonName: "Mute"),
        RemoteButton(buttonName: "Channel Up"),
        RemoteButton(buttonName: "Channel Down"),
        RemoteButton(buttonName: "Volume Up"),
        RemoteButton(buttonName: "Volume Down"),
        RemoteButton(buttonName: "Menu"),
        RemoteButton(buttonName: "Input"),
        RemoteButton(buttonName: "Exit"),
        RemoteButton(buttonName: "Home"),
        RemoteButton(buttonName: "Back"),
        RemoteButton(buttonName: "Up"),
        RemoteButton(buttonName: "Down"),
        RemoteButton(buttonName: "Left"),
        RemoteButton(buttonName: "Right"),
        RemoteButton(buttonName: "OK"),
        RemoteButton(buttonName: "1"),
        RemoteButton(buttonName: "2"),
        RemoteButton(buttonName: "3"),
        RemoteButton(buttonName: "4"),
        RemoteButton(buttonName: "5"),
        RemoteButton(buttonName: "6"),
        RemoteButton(buttonName: "7"),
        RemoteButton(buttonName: "8"),
        RemoteButton(buttonName: "9"),
        RemoteButton(buttonName: "0"),
    ]
    var frequency: Int = 38000
    var alarms: Array<Alarm> = []
    var sequnce: Array<buttonInSequence> = []
}

enum alarmRepeat: CaseIterable{
    case none
    case daily
    case weekly
    case monthly
    case yearly
    
    var text: String{
        switch self{
        case .none:
            return "None"
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        }
    }
}

struct Alarm{
    var dateTime: Date
    var repeatFrequency: alarmRepeat
    var enabled: Bool
}

//Alarm
func saveAlarm(TVID: Int, newAlarm: Alarm)-> String{
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID{
            for j in 0...(TVs[i].alarms.count - 1){
                if TVs[i].alarms[j].dateTime == newAlarm.dateTime{
                    return "An alarm for that Time Already Exists."
                }
            }
            TVs[i].alarms.append(newAlarm)
            print(TVs)
            return "Alarm Sucessfully Added."
        }
    }
    return "Alarm could not be saved."
}

func editAlarm(TVID: Int, oldAlarm:Alarm, newAlarm:Alarm) -> String{
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID{
            for j in 0...(TVs[i].alarms.count-1){
                if TVs[i].alarms[j].dateTime == newAlarm.dateTime{
                    return "An alarm for that Time Already Exists."
                }
            }            
            TVs[i].alarms.append(newAlarm)
            print(TVs)
            deleteAlarm(TVID: TVID, alarmToDelete: oldAlarm)
            return "Sucessfully Edited."
        }
    }
    return "Alarm could not be saved."
}

func deleteAlarm(TVID: Int, alarmToDelete: Alarm){
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            for j in 0...(TVs[i].alarms.count - 1){
                if TVs[i].alarms[j].dateTime == alarmToDelete.dateTime{
                    TVs[i].alarms.remove(at: j)
                    print(TVs)
                    return
                }
            }
        }
    }
}

func getListOfAlarms(TVID: Int)-> Array<Alarm>{
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            print(TVs)
            return TVs[i].alarms
        }
    }
    return []
}

func toggleAlarm(TVID: Int, alarmToChange: Alarm){
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            for j in 0...(TVs[i].alarms.count - 1){
                if TVs[i].alarms[j].dateTime == alarmToChange.dateTime{
                    TVs[i].alarms[j].enabled.toggle()
                }
            }
        }
    }
}

//Button
func pressButton(TVID: Int, pressedButton: RemoteButton){
    print("TV: \(getTV(TVID: TVID).name) Button: \(pressedButton.buttonName)")
}

func getButton(TVID: Int, buttonName: String) -> RemoteButton{
    var TVIndex: Int = 0
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            TVIndex = i
            for j in 0...(TVs[i].arrayOfButtons.count - 1){
                if TVs[i].arrayOfButtons[j].buttonName == buttonName{
                    return TVs[i].arrayOfButtons[j]
                }
            }
        }
    }
    return TVs[TVIndex].arrayOfButtons[0]
}

func getButtonList(TVID: Int) -> Array<RemoteButton>{
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            return TVs[i].arrayOfButtons
        }
    }
    return []
}

func deleteButton(TVID: Int, ButtonName: String) -> String{
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            for j in 0...(TVs[i].arrayOfButtons.count - 1){
                if TVs[i].arrayOfButtons[j].buttonName == ButtonName{
                    TVs[i].arrayOfButtons.remove(at: j)
                    print(TVs)
                    for k in 0...(TVs[i].sequnce.count - 1){
                        if TVs[i].sequnce[k].buttonName == ButtonName{
                            TVs[i].sequnce.remove(at: k)
                        }
                    }
                    return "Sucess"
                }
            }
        }
    }
    return "Could not be found"
}

func editButton(TVID: Int, ButtonName: String, newButtonName: String?, newSignal: Array<UInt16>) -> String{
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            for j in 0...(TVs[i].arrayOfButtons.count - 1){
                if TVs[i].arrayOfButtons[j].buttonName == ButtonName{
                    if newButtonName != nil {
                        TVs[i].arrayOfButtons[j].buttonName = newButtonName ?? ButtonName
                    }
                    if newSignal != [] {
                        TVs[i].arrayOfButtons[j].signal = newSignal
                    }
                    for k in 0...(TVs[i].sequnce.count - 1){
                        if (TVs[i].sequnce[k].buttonName == ButtonName && newButtonName != nil){
                            TVs[i].sequnce[k].buttonName = newButtonName!
                        }
                    }
                    print(TVs)
                    return "Sucessfully Edited."
                }
            }
        }
    }
    return "Error! Go Back and Try again."
}

func detectSignal() -> Array<UInt16>{
    return [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67]
}

func saveButton(TVID: Int, ButtonName: String, Signal: Array<UInt16>)-> String{
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            for j in 0...(TVs[i].arrayOfButtons.count - 1){
                if TVs[i].arrayOfButtons[j].buttonName == ButtonName{
                    print(TVs)
                    return "Button Name Already Exists"
                }
            }
            TVs[i].arrayOfButtons.append(RemoteButton(buttonName: ButtonName, signal: Signal))
            print(TVs)
            return "Saved"
        }
    }
    return "Error! Go Back and Try again."
}

//TV
func getTVList() -> Array<TV>{
    print(TVs)
    return TVs
}

func addTV(tVName: String) -> String{
    if tVName.count <= 30{
        var id = 1
        var found = true
        while(found){
            found = false
            for i in 0...(TVs.count - 1){
                if (TVs[i].TVID == id){
                    id += 1
                    found = true
                }
            }
        }
        TVs.append(TV(TVID: id, name: tVName))
        return "Sucessfully Added \(tVName)"
    }
    else{
        return "TV name can only be 30 Characters Long"
    }
}

func deleteTV(TVID: Int) -> String{
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            TVs.remove(at: i)
            return "Sucess"
        }
    }
    return "Could not find TV."
}

func editTVName(TVID: Int, TVNewName: String) -> String {
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            TVs[i].name = TVNewName
            return "Sucess"
        }
    }
    return "Could not find TV."
}

func listSequences(TVID: Int) -> Array<buttonInSequence>{
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            return TVs[i].sequnce
        }
    }
    return []
}

func addButtonInSequence(TVID: Int, buttonName: String, numOfRepeat: Int)-> String {
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            var sequenceID = 0
            var found = true
            while(found){
                found = false
                for j in 0...(TVs[i].sequnce.count - 1){
                    if (TVs[i].sequnce[j].sequenceID == sequenceID){
                        sequenceID += 1
                        found = true
                    }
                }
            }
            TVs[i].sequnce.append(buttonInSequence(sequenceID: sequenceID, buttonName: buttonName, numOfRepeat: numOfRepeat))
            return "Sucess"
        }
    }
    return "Could Not Find TV"
}

func deleteButtonOnSequence(TVID: Int, sequenceID: Int) -> String{
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            for j in 0...(TVs[i].sequnce.count - 1){
                if TVs[i].sequnce[j].sequenceID == sequenceID{
                    TVs[i].sequnce.remove(at: j)
                    return "Sucess"
                }
            }
        }
    }
    return "Could Not Find TV"
}

func getTV()-> TV{
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == currentTVID {
            return TVs[i]
        }
    }
    return TVs[0]
}

func getTV(TVID: Int)-> TV{
    for i in 0...(TVs.count - 1){
        if TVs[i].TVID == TVID {
            return TVs[i]
        }
    }
    return TVs[0]
}

func selectTV(TVID: Int){
    currentTVID = TVID
}

