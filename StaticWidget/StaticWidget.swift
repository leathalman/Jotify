//
//  StaticWidget.swift
//  StaticWidget
//
//  Created by Harrison Leath on 10/12/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import WidgetKit
import SwiftUI
import UIKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), content: String(), dateString: String())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let snapString = "Hey there! I'm some really cool placeholder text :)"
        let entry = SimpleEntry(date: Date(), content: snapString, dateString: "January 1, 2000")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let content = GroupDataManager().readData(path: "widgetContent")
        let dateString = GroupDataManager().readData(path: "widgetDate")
        let entry = SimpleEntry(date: currentDate, content: content, dateString: dateString)
        entries.append(entry)
        
        print("WIDGET STUFF: \( GroupDataManager().readData(path: "widgetColor"))")
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let content: String
    let dateString: String
}

struct StaticWidgetEntryView : View {
    var entry: Provider.Entry
    
    var widgetColor: Color = ColorCrap().colorFromString(string: GroupDataManager().readData(path: "widgetColor"))
    
    let color: Color = UIColor.thing(string: GroupDataManager().readData(path: "widgetColor"))
    
    var body: some View {
        widgetColor.overlay(
            VStack(alignment: .center, spacing: 6) {
                Text(entry.content).font(.system(size: 15, weight: .bold, design: .default)).multilineTextAlignment(.leading)
                Spacer()
                Text(entry.dateString).font(.system(size: 13, weight: .medium, design: .default)).multilineTextAlignment(.center)
            }
            .padding(.all, 13)
        )
    }
}

@main
struct StaticWidget: Widget {
    let kind: String = "StaticWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StaticWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Static_Widget_Previews: PreviewProvider {
    static var previews: some View {
        StaticWidgetEntryView(entry: SimpleEntry(date: Date(), content: "Hello, World! This is a much longer string because I want to know what happens when I put a really long string in here does the text know ", dateString: "January 1, 2000"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small widget")
        StaticWidgetEntryView(entry: SimpleEntry(date: Date(), content: "Hello, World - this an awkward amount of data but honestly I think it looks really good, nice!", dateString: "January 1, 2000"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small widget")
    }
}
