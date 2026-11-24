//
//  NoteCollectionController+Search.swift
//  Jotify
//
//  Created by Harrison Leath on 5/3/21.
//

import SwiftUI

extension NoteCollectionController {

    /// Notes whose text or displayed date contains the query.
    func matches(for searchText: String) -> [FBNote] {
        let query = searchText.lowercased()
        return (noteCollection?.FBNotes ?? []).filter { note in
            note.content.lowercased().contains(query) ||
            note.timestamp.getDate().lowercased().contains(query) ||
            SavedNoteCell.shortDate(note.timestamp).lowercased().contains(query)
        }
    }

    var searchText: String {
        searchModel.text
    }

    var isFiltering: Bool {
        !searchText.isEmpty
    }
}

/// Search text shared between the SwiftUI bar and the notes grid.
final class NotesSearchModel: ObservableObject {
    @Published var text = "" {
        didSet { if text != oldValue { onChange?(text) } }
    }
    var onChange: ((String) -> Void)?
}

/// Floating search capsule + compose button, Liquid Glass on iOS 26
/// (material before that), in the style of Notes and Mail.
struct NotesBottomBar: View {
    @ObservedObject var model: NotesSearchModel
    var onCompose: () -> Void
    var onBeginSearch: () -> Void

    @FocusState private var isSearching: Bool

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search Notes", text: $model.text)
                    .focused($isSearching)
                    .submitLabel(.search)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                if !model.text.isEmpty {
                    Button {
                        model.text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel("Clear Search")
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .modifier(GlassBackground(shape: Capsule()))

            // While searching the round button cancels; otherwise it composes.
            Button {
                if isSearching {
                    model.text = ""
                    isSearching = false
                } else {
                    onCompose()
                }
            } label: {
                Image(systemName: isSearching ? "xmark" : "square.and.pencil")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 48, height: 48)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .modifier(GlassBackground(shape: Circle()))
            .accessibilityLabel(isSearching ? "Cancel Search" : "New Note")
        }
        .tint(.primary)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .onChange(of: isSearching) { _, searching in
            if searching { onBeginSearch() }
        }
    }
}

private struct GlassBackground<S: Shape>: ViewModifier {
    let shape: S

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.glassEffect(.regular.interactive(), in: shape)
        } else {
            content.background(.regularMaterial, in: shape)
        }
    }
}
