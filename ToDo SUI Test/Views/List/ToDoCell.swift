//
//  ToDoCell.swift
//  ToDo SUI Test
//
//  Created by Augusto Galindo Alí on 23/07/21.
//

import SwiftUI

struct ToDoCell: View {
    @EnvironmentObject var dataStore: DataStore
    @ObservedObject var formVM: ToDoFormViewModel
    
    var toDo: ToDo
    
    init(toDo: ToDo) {
        self.toDo = toDo
        self.formVM = ToDoFormViewModel(toDo)
    }
    
    var body: some View {
        HStack {
            Button(action: {
                formVM.isComplete.toggle()
                let toDo = ToDo(id: formVM.id!, title: formVM.title, isComplete: formVM.isComplete, dueDate: formVM.dueDate, notes: formVM.notes)
                dataStore.updateToDo.send(toDo)
            }, label: {
                if toDo.isComplete {
                    Image(systemName: "largecircle.fill.circle")
                        .imageScale(.medium)
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "circle")
                        .imageScale(.medium)
                        .foregroundColor(.gray)
                }
            })
            .buttonStyle(PlainButtonStyle())
            Spacer().frame(width: 12)
            Text(toDo.title)
        }
    }
}

struct ToDoCell_Previews: PreviewProvider {
    static var previews: some View {
        ToDoCell(toDo: ToDo.sampleData[0])
            .environmentObject(DataStore())
    }
}
