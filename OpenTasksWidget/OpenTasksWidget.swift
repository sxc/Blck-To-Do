//
//  OpenTasksWidget.swift
//  OpenTasksWidget
//
//  Created by Xiaochun Shen on 2021/1/7.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let sampleTaskTitles = ["Learning swiftUI", "Hitting the gym"]
}

struct OpenTasksWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemLarge:
            Text("View for larget widget")
        case .systemMedium:
            HStack {
                VStack(alignment: .leading) {
                    Text("\(entry.sampleTaskTitles.count)")
                    Text("open")
                    Text("tasks")
                }
                .font(.title)
                .foregroundColor(.blue)
                Divider()
                VStack(alignment: .leading) {
                    ForEach(entry.sampleTaskTitles.prefix(3), id: \.self) { item in
                        Text(item ?? "")
                            .padding(.top, 3)
                            .lineLimit(1)
                    }
                    if entry.sampleTaskTitles.count > 3 {
                        Text("More ...")
                            .padding(.top, 3)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
            
        case .systemSmall:
            
            VStack(alignment: .leading) {
                Text("\(entry.sampleTaskTitles.count) open tasks")
                    .foregroundColor(.blue)
                    .font(.headline)
                    .padding(.top, 2)
                Divider()
                ForEach(entry.sampleTaskTitles.prefix(3), id: \.self) { item in
                    Text(item ?? "")
                        .font(.caption)
                        .padding(.bottom, 2)
                        .lineLimit(1)
                }
                if entry.sampleTaskTitles.count > 3 {
                    Text("More ...")
                        .font(.caption)
                        .padding(.top, 2)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
                .padding()
    
 
        default:
            Text("View for small widget")
        
        }
    }
}

@main
struct OpenTasksWidget: Widget {
    let kind: String = "OpenTasksWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            OpenTasksWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct OpenTasksWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OpenTasksWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            OpenTasksWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            OpenTasksWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
            
        }
    }
}
