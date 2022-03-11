//
//  ToDoListView.swift
//  ToDo SUI Test
//
//  Created by Augusto Galindo Alí on 15/06/21.
//

import SwiftUI

struct ToDoListView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var isActive = false
    
    var body: some View {
        NavigationView() {
            List() {
                ForEach(dataStore.toDos.value) { toDo in
                    NavigationLink(
                        destination: ToDoDetailView(formVM: ToDoFormViewModel(toDo)),
                        label: {
                            ToDoCell(toDo: toDo)
                    })
                }
                .onMove { (indexSet, index) in
                    dataStore.toDos.value.move(fromOffsets: indexSet, toOffset: index)
                    dataStore.updateView()
                }
                .onDelete(perform: dataStore.deleteToDo.send)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("My To-Do's")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    isActive.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            )
        }
        .sheet(isPresented: $isActive) {
            ToDoEditView(formVM: ToDoFormViewModel())
        }
        .alert(item: $dataStore.appError.value) { appError in
            Alert(title: Text("Oh Oh"), message: Text(appError.error.localizedDescription))
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    @EnvironmentObject var dataStore: DataStore
    
    static var previews: some View {
        ToDoListView()
            .environmentObject(DataStore())
    }
    
//    func addToDo() {
//        for toDo in ToDo.sampleData {
//            dataStore.addToDo.send(toDo)
//        }
//    }
    
}
