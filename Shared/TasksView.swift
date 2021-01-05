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
                ForEach(sampleTasks, id: \.self) { item in
                    
                    // To-Do's (dynamic row(s))
                    
                    HStack {
                        Text(item)
                        Spacer()
                        Button(action: {
                            print("Task Done.")
                        }) {
                        Image(systemName: "circle")
                            .imageScale(.large)
                            .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: rowHeight)
                
                // Row for adding a new task (static row)
                
                HStack {
                    TextField("Add task...", text: $newTaskTitle, onCommit: {print("New task title entered.")})
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
                .frame(height: rowHeight)
                
                
                
                
                
                // Row for navigating to the view containing accomplished tasks (static row)
                Text("Tasks done")
                    .frame(height: rowHeight)
                
                
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("To-Do")
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
