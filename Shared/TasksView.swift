//
//  TasksView.swift
//  Blck To-Do
//
//  Created by Xiaochun Shen on 2021/1/5.
//

import SwiftUI


var rowHeight: CGFloat = 50

struct TasksView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: ToDoItem.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.createdAt, ascending: false)],
                  predicate: NSPredicate(format: "taskDone = %d", false), animation: .default)
    var fetchedItems: FetchedResults<ToDoItem>
    
    
    @State var newTaskTitle = ""
    
    var sampleTasks = [
    "Task One", "Task Two", "Task Three"
    ]
    var body: some View {
        
        NavigationView {
            List {
                ForEach(fetchedItems, id: \.self) { item in
                    
                    // To-Do's (dynamic row(s))
                    
                    HStack {
//                        Text(item)
                        Text(item.taskTitle ?? "Empty")
                        
                        Spacer()
                        
                        Button(action: {
//                            print("Task Done.")
                            markTaskAsDone(at: fetchedItems.firstIndex(of: item)!)
                        }) {
                        Image(systemName: "circle")
                            .imageScale(.large)
                            .foregroundColor(.gray)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .frame(height: rowHeight)
                
                // Row for adding a new task (static row)
                
                HStack {
                    TextField("Add task...", text: $newTaskTitle, onCommit: {
//                        print("New task title entered.")
                        saveTask()
                        
                    })
                    Button(action: {
                        saveTask()
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                    
                   
                }
                .frame(height: rowHeight)
                // Row for navigating to the view containing accomplished tasks (static row)
                
                NavigationLink(
                    destination: TasksDoneView()) {
                        Text("Tasks done")
                            .frame(height: rowHeight)
                    }
                
                   
                
                
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("To-Do")
        }
    }
    
    func saveTask() {
        guard self.newTaskTitle != "" else {
            return
            
        }
        
        let newToDoItem = ToDoItem(context: viewContext)
        newToDoItem.taskTitle = newTaskTitle
        newToDoItem.createdAt = Date()
        newToDoItem.taskDone = false
        
        do  {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
        newTaskTitle = ""
    }
    
    func markTaskAsDone(at index: Int) {
        let item = fetchedItems[index]
        item.taskDone = true
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    
}


struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
