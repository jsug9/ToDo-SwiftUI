//
//  ToDoEditView.swift
//  Watch ToDo Extension
//
//  Created by Augusto Galindo Alí on 4/08/21.
//

import SwiftUI

struct ToDoEditView: View {
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
                    .buttonStyle(PlainButtonStyle())
                    TextField("Remind me to...", text: $formVM.title)
                        .foregroundColor(.blue)
                    Spacer()
                }
                
            }
            
            Section() {
                updateSaveButton
            }
        }
        .navigationTitle(formVM.updating ? "Edit To-Do" : "New To-Do")
    }
}

extension ToDoEditView {
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
        Button(action: {
            formVM.updating ? updateToDo() : addToDo()
        }, label: {
            HStack() {
                Spacer()
                Text(formVM.updating ? "Update" : "Save")
                    .foregroundColor(.blue)
                Spacer()
            }
        })
        .disabled(formVM.isDisabled)
    }
}

struct ToDoEditView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoEditView(formVM: ToDoFormViewModel())
            .environmentObject(DataStore())
    }
}
