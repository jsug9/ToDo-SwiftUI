//
//  ToDoWatchListView.swift
//  Watch ToDo Extension
//
//  Created by Augusto Galindo Alí on 4/08/21.
//

import SwiftUI

struct ToDoWatchListView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var isActive = false
    
    var body: some View {
        NavigationView {
            List() {
                ForEach(dataStore.toDos.value) { toDo in
                    NavigationLink(
                        destination: ToDoEditView(formVM: ToDoFormViewModel(toDo)),
                        label: {
                            ToDoCell(toDo: toDo)
                    })
                }
                .onMove { (indexSet, index) in
                    dataStore.toDos.value.move(fromOffsets: indexSet, toOffset: index)
                    dataStore.updateView()
                }
                .onDelete(perform: dataStore.deleteToDo.send)
                NavigationLink(
                    destination: ToDoEditView(formVM: ToDoFormViewModel()),
                    label: {
                        HStack {
                            Spacer()
                            Text("Add ToDo")
                                .foregroundColor(.blue)
                            Spacer()
                        }
                })
            }
            .navigationTitle("My To-Do's")
        }
    }
}

struct ToDoWatchListView_Previews: PreviewProvider {
    @EnvironmentObject var dataStore: DataStore
    
    static var previews: some View {
        ToDoWatchListView()
            .environmentObject(DataStore())
    }
}
