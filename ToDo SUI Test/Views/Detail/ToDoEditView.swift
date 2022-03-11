//
//  ToDoEditView.swift
//  ToDo SUI Test
//
//  Created by Augusto Galindo Alí on 15/06/21.
//

import SwiftUI

struct ToDoEditView: View {
    @EnvironmentObject var dataStore: DataStore
    @ObservedObject var formVM: ToDoFormViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var initialToDo: ToDo
    
    init(formVM: ToDoFormViewModel) {
        self.formVM = formVM
        if formVM.updating {
            _initialToDo = State(initialValue: ToDo(id: formVM.id!, title: formVM.title, isComplete: formVM.isComplete, dueDate: formVM.dueDate, notes: formVM.notes))
        } else {
            _initialToDo = State(initialValue: ToDo.sampleData[1])
        }
    }
    
    var body: some View {
        NavigationView {
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
                        TextField("Remind me to...", text: $formVM.title)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Section() {
                    DatePicker(selection: self.$formVM.dueDate) {
                        Text("Due Date:")
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $formVM.notes)
                        .foregroundColor(.blue)
                        .frame(height: 120)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(formVM.updating ? "Edit To-Do" : "New To-Do", displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: updateSaveButton)
        }
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
            if formVM.updating {
                dataStore.updateToDo.send(initialToDo)
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var updateSaveButton: some View {
        Button(formVM.updating ? "Update" : "Save", action: formVM.updating ? updateToDo : addToDo)
            .disabled(formVM.isDisabled)
    }
}

struct ToDoEditView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoEditView(formVM: ToDoFormViewModel())
            .environmentObject(DataStore())
    }
}

//enum AddOrUpdate {
//    case add, update
//}
//
//func updateAddToDo(_ addOrUpdate: AddOrUpdate) {
//    let toDo = ToDo(id: formVM.id!, title: formVM.title, isComplete: formVM.isComplete, dueDate: formVM.dueDate, notes: formVM.notes)
//    
//    switch addOrUpdate {
//    case .add:
//        dataStore.addToDo.send(toDo)
//    case .update:
//        dataStore.updateToDo.send(toDo)
//    }
//    
//    presentationMode.wrappedValue.dismiss()
//}
