//
//  ToDo.swift
//  ToDo SUI Test
//
//  Created by Augusto Galindo Alí on 15/06/21.
//

import Foundation

struct ToDo: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String
    
    static var sampleData: [ToDo] {
        let todo1 = ToDo(title: "ToDo One", isComplete: false, dueDate: Date() - 86400 * 2, notes: "Notes 1")
        let todo2 = ToDo(title: "ToDo Two", isComplete: true, dueDate: Date() - 86400 * 3, notes: "Notes 2")
        let todo3 = ToDo(title: "ToDo Three", isComplete: false, dueDate: Date() - 86400 * 6, notes: "Notes 3")
        
        return [todo1, todo2, todo3]
    }
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
