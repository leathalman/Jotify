//
//  RecentNoteWidget.swift
//  RecentNoteWidget
//
//  Created by Harrison Leath on 7/9/21.
//

import WidgetKit
import SwiftUI
import UIKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RecentNoteEntry {
        return RecentNoteEntry(date: Date(), content: String(), dateString: String())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RecentNoteEntry) -> ()) {
        let entry = RecentNoteEntry(date: Date(), content: GroupDataManager.readData(path: "recentNoteContent"), dateString: GroupDataManager.readData(path: "recentNoteDate"))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [RecentNoteEntry] = []
        
        let content = GroupDataManager.readData(path: "recentNoteContent")
        let dateString = GroupDataManager.readData(path: "recentNoteDate")
        let entry = RecentNoteEntry(date: Date(), content: content, dateString: dateString)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct RecentNoteEntry: TimelineEntry {
    let date: Date
    let content: String
    let dateString: String
}

struct ContentView: View {
    var widgetColor: Color = Color(GroupDataManager.readData(path: "recentNoteColor").getColor())
    
    var textColor = GroupDataManager.readData(path: "recentNoteColor").getColor().isDarkColor ? UIColor.white : UIColor.black
    
    var entry: Provider.Entry
    
    var body: some View {
        widgetColor.overlay(
            VStack(alignment: .center, spacing: 6) {
                Text(entry.content).font(.system(size: 15, weight: .bold, design: .default)).multilineTextAlignment(.leading)
                    .foregroundColor(Color(textColor))
                Spacer()
                Text(entry.dateString).font(.system(size: 13, weight: .medium, design: .default)).multilineTextAlignment(.center)
                    .foregroundColor(Color(textColor))
            }
            .padding(.all, 12)
        )
    }
    
}

struct RecentNoteEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: Provider.Entry
    
    var deeplinkURL: URL {
        URL(string: "recentnotewidget-link://widgetFamily/\(widgetFamily)")!
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
struct RecentNote: Widget {
    let kind: String = "RecentNote"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RecentNoteEntryView(entry: entry)
        }
        .configurationDisplayName("Recent Note")
        .description("Updates dynamically to display your most recent note.")
    }
}

struct RecentNote_Widget_Previews: PreviewProvider {
    static var previews: some View {
        RecentNoteEntryView(entry: RecentNoteEntry(date: Date(), content: "Hello, World! This is a much longer string because I want to know what happens when I put a really long string in here does the text know ", dateString: "January 1, 2000"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small widget")
        RecentNoteEntryView(entry: RecentNoteEntry(date: Date(), content: "Hello, World - this an awkward amount of data but honestly I think it looks really good, nice!", dateString: "January 1, 2000"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small widget")
    }
}
