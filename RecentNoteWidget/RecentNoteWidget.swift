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
        RecentNoteEntry(date: Date(), content: "Pick up milk\nand call Sam back", dateString: "Today", color: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (RecentNoteEntry) -> ()) {
        completion(context.isPreview ? placeholder(in: context) : Self.currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // The app reloads timelines whenever the newest note changes.
        completion(Timeline(entries: [Self.currentEntry()], policy: .never))
    }

    private static func currentEntry() -> RecentNoteEntry {
        RecentNoteEntry(date: Date(),
                        content: GroupDataManager.readData(path: "recentNoteContent"),
                        dateString: GroupDataManager.readData(path: "recentNoteDate"),
                        color: GroupDataManager.readData(path: "recentNoteColor"))
    }
}

struct RecentNoteEntry: TimelineEntry {
    let date: Date
    let content: String
    let dateString: String
    /// Theme name of the note (see `String.getColor()`); empty for the brand navy.
    let color: String
}

struct RecentNoteEntryView: View {
    @Environment(\.widgetFamily) private var widgetFamily

    var entry: Provider.Entry

    private var noteColor: UIColor {
        entry.color.isEmpty ? UIColor(named: "WidgetBackground") ?? .systemBlue : entry.color.getColor()
    }

    private var textColor: Color {
        noteColor.isDarkColor ? .white : .black
    }

    private var deeplinkURL: URL {
        URL(string: "recentnotewidget-link://widgetFamily/\(widgetFamily)")!
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if entry.content.isEmpty {
                Label("Jotify", systemImage: "square.and.pencil")
                    .font(.headline)
                    .widgetAccentable()
                Spacer(minLength: 0)
                Text("Your latest note will appear here.")
                    .font(.subheadline)
                    .opacity(0.8)
            } else {
                Text(entry.content)
                    .font(.headline)
                    .lineLimit(widgetFamily == .systemSmall ? 5 : 4)
                    .widgetAccentable()
                Spacer(minLength: 0)
                Text(entry.dateString)
                    .font(.caption)
                    .opacity(0.75)
            }
        }
        .foregroundStyle(textColor)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(for: .widget) {
            Color(noteColor)
        }
        .widgetURL(deeplinkURL)
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
        .description("Shows your most recent note.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    RecentNote()
} timeline: {
    RecentNoteEntry(date: .now, content: "Pick up milk\nand call Sam back", dateString: "Today", color: "")
    RecentNoteEntry(date: .now, content: "", dateString: "", color: "")
}
