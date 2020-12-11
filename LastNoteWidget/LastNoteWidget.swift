//
//  LastNoteWidget.swift
//  Jotify
//
//  Created by Harrison Leath on 12/9/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import WidgetKit
import SwiftUI
import UIKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> LastNoteEntry {
        return LastNoteEntry(date: Date(), content: String(), dateString: String())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LastNoteEntry) -> ()) {
        let entry = LastNoteEntry(date: Date(), content: GroupDataManager().readData(path: "widgetContent"), dateString: GroupDataManager().readData(path: "widgetDate"))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [LastNoteEntry] = []
        
        let currentDate = Date()
        let content = GroupDataManager().readData(path: "widgetContent")
        let dateString = GroupDataManager().readData(path: "widgetDate")
        let entry = LastNoteEntry(date: currentDate, content: content, dateString: dateString)
        entries.append(entry)
        
        print("WIDGET STUFF: \( GroupDataManager().readData(path: "widgetColor"))")
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct LastNoteEntry: TimelineEntry {
    let date: Date
    let content: String
    let dateString: String
}

struct ContentView: View {
    var widgetColor: Color = WidgetColorInterpretor().colorFromString(string: GroupDataManager().readData(path: "widgetColor"))
    
    var entry: Provider.Entry
    
    var body: some View {
        widgetColor.overlay(
            VStack(alignment: .center, spacing: 6) {
                Text(entry.content).font(.system(size: 15, weight: .bold, design: .default)).multilineTextAlignment(.leading)
                Spacer()
                Text(entry.dateString).font(.system(size: 13, weight: .medium, design: .default)).multilineTextAlignment(.center)
            }
            .padding(.all, 12)
        )
    }
    
}

struct LastNoteEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: Provider.Entry
    
    var deeplinkURL: URL {
        URL(string: "lastnotewidget-link://widgetFamily/\(widgetFamily)")!
    }
    
    var body: some View {
        if widgetFamily == .systemSmall {
            ContentView(entry: entry).widgetURL(deeplinkURL)
        } else {
            Link(destination: deeplinkURL) {
                ContentView(entry: entry)
            }
        }
    }
}

@main
struct LastNote: Widget {
    let kind: String = "LastNote"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LastNoteEntryView(entry: entry)
        }
        .configurationDisplayName("Last Note")
        .description("Displays your most recent note.")
    }
}

struct LastNote_Widget_Previews: PreviewProvider {
    static var previews: some View {
        LastNoteEntryView(entry: LastNoteEntry(date: Date(), content: "Hello, World! This is a much longer string because I want to know what happens when I put a really long string in here does the text know ", dateString: "January 1, 2000"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small widget")
        LastNoteEntryView(entry: LastNoteEntry(date: Date(), content: "Hello, World - this an awkward amount of data but honestly I think it looks really good, nice!", dateString: "January 1, 2000"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small widget")
    }
}
