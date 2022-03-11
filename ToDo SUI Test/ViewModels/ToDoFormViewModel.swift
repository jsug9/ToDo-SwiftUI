//
//  ToDoFormViewModel.swift
//  ToDo SUI Test
//
//  Created by Augusto Galindo Alí on 15/06/21.
//

import Foundation

class ToDoFormViewModel: ObservableObject {
    @Published var title = ""
    @Published var isComplete = false
    @Published var dueDate = Date()
    @Published var notes = ""
    
    var id: String?
    
    var updating: Bool {
        id != nil
    }
    
    var isDisabled: Bool {
        title.isEmpty
    }
    
    init() {}
    
    init(_ currentToDo: ToDo) {
        self.title = currentToDo.title
        self.isComplete = currentToDo.isComplete
        self.dueDate = currentToDo.dueDate
        self.notes = currentToDo.notes
        id = currentToDo.id
    }
    
}
