//
//  TasksDoneView.swift
//  Blck To-Do
//
//  Created by Xiaochun Shen on 2021/1/7.
//

import SwiftUI

struct TasksDoneView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(entity: ToDoItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.createdAt, ascending: false)], predicate: NSPredicate(format: "taskDone = %d", true), animation: .default)

    var fetchedItem: FetchedResults<ToDoItem>
    
    var body: some View {
        
        List {
            ForEach(fetchedItem, id: \.self) { item in
                HStack {
                    Text(item.taskTitle ?? "Empty")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.blue)
            }

                .frame(height: rowHeight)
           
        }
            .onDelete(perform: removeItems)
        }
        .navigationBarTitle(Text("Tasks done"))
        .navigationBarItems(trailing: EditButton())
        .listStyle(GroupedListStyle())
        
    }
    
    
    private func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let item = fetchedItem[index]
            viewContext.delete(item)
        }
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
}



struct TasksDoneView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            TasksDoneView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
