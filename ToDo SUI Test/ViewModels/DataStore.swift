//
//  DataStore.swift
//  ToDo SUI Test
//
//  Created by Augusto Galindo Alí on 15/06/21.
//

import Foundation
import Combine

class DataStore: ObservableObject {
//    @Published var toDos = [ToDo]()
    var toDos = CurrentValueSubject<[ToDo], Never>([])
//    @Published var appError: ErrorType?
    var appError = CurrentValueSubject<ErrorType?, Never>(nil)
    var addToDo = PassthroughSubject<ToDo, Never>()
    var updateToDo = PassthroughSubject<ToDo, Never>()
    var deleteToDo = PassthroughSubject<IndexSet, Never>()
    var loadToDos = Just(FileManager.docDirURL.appendingPathComponent(fileName))
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        print(FileManager.docDirURL.path)
        addSubscriptions()
    }
    
    func addSubscriptions() {
        appError
            .sink { _ in
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
        
        loadToDos
            .filter { FileManager.default.fileExists(atPath: $0.path) }
            .tryMap { url in
                try Data(contentsOf: url)
            }
            .decode(type: [ToDo].self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    print("Loading")
                    toDosSubscription()
                case .failure(let error):
                    if error is ToDoError {
                        appError.send(ErrorType(error: error as! ToDoError))
                    } else {
                        appError.send(ErrorType(error: ToDoError.decodingError))
                        toDosSubscription()
                    }
                }
            } receiveValue: { (toDos) in
                self.objectWillChange.send()
                self.toDos.value = toDos
            }
            .store(in: &subscriptions)
        
        addToDo.sink { [unowned self] toDo in
            self.objectWillChange.send()
            toDos.value.append(toDo)
        }
        .store(in: &subscriptions)
        
        updateToDo.sink { [unowned self] toDo in
            guard let index = toDos.value.firstIndex(where: { $0.id == toDo.id}) else { return }
            self.objectWillChange.send()
            toDos.value[index] = toDo
        }
        .store(in: &subscriptions)
        
        deleteToDo.sink { [unowned self] indexSet in
            self.objectWillChange.send()
            toDos.value.remove(atOffsets: indexSet)
        }
        .store(in: &subscriptions)
    }
    
    func toDosSubscription() {
        toDos
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .encode(encoder: JSONEncoder())
            .tryMap { data in
                try data.write(to: FileManager.docDirURL.appendingPathComponent(fileName))
            }
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    print("Saving Completed")
                case .failure(let error):
                    if error is ToDoError {
                        appError.send(ErrorType(error: error as! ToDoError))
                    } else {
                        appError.send(ErrorType(error: ToDoError.encodingError))
                    }
                }
            } receiveValue: { _ in
                print("Saving file was successful")
            }
            .store(in: &subscriptions)
    }
    
    func updateView() {
        self.objectWillChange.send()
    }
}
