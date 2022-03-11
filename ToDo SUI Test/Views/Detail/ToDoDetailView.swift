//
//  ToDoDetailView.swift
//  ToDo SUI Test
//
//  Created by Augusto Galindo Alí on 3/08/21.
//

import SwiftUI

struct ToDoDetailView: View {
    @EnvironmentObject var dataStore: DataStore
    @ObservedObject var formVM: ToDoFormViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isPresented = false
    
    var body: some View {
        List() {
            Section(header: Text("Basic Information")) {
                HStack {
                    Button(action: {
                        formVM.isComplete.toggle()
                        let toDo = ToDo(id: formVM.id!, title: formVM.title, isComplete: formVM.isComplete, dueDate: formVM.dueDate, notes: formVM.notes)
                        dataStore.updateToDo.send(toDo)
                    }, label: {
                        if formVM.isComplete {
                            Image(systemName: "largecircle.fill.circle")
                                .imageScale(.medium)
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "circle")
                                .imageScale(.medium)
                                .foregroundColor(.gray)
                        }
                    })
                    Text(formVM.title)
                    Spacer()
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Section() {
                HStack {
                    Text("Due Date:")
                    Spacer()
                    Text(ToDo.dueDateFormatter.string(from: formVM.dueDate))
                }
            }
            
            Section(header: Text("Notes")) {
                Text(formVM.notes)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(formVM.updating ? "Edit To-Do" : "New To-Do", displayMode: .inline)
        .navigationBarItems(trailing: Button("Edit") {
            isPresented.toggle()
        })
//        .onDisappear(perform: {
//            updateToDo()
//        })
        .fullScreenCover(isPresented: $isPresented) {
            ToDoEditView(formVM: formVM)
        }
    }
}

extension ToDoDetailView {
    
    func updateToDo() {
        let toDo = ToDo(id: formVM.id!, title: formVM.title, isComplete: formVM.isComplete, dueDate: formVM.dueDate, notes: formVM.notes)
        dataStore.updateToDo.send(toDo)
        presentationMode.wrappedValue.dismiss()
    }
    
    func addToDo() {
        let toDo = ToDo(title: formVM.title, isComplete: formVM.isComplete, dueDate: formVM.dueDate, notes: formVM.notes)
        dataStore.addToDo.send(toDo)
        presentationMode.wrappedValue.dismiss()
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var updateSaveButton: some View {
        Button(formVM.updating ? "Update" : "Save", action: formVM.updating ? updateToDo : addToDo)
            .disabled(formVM.isDisabled)
    }
}

struct ToDoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoDetailView(formVM: ToDoFormViewModel())
            .environmentObject(DataStore())
    }
}
