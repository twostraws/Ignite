//
// Event.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// One event that can trigger a series of actions, such as
/// an onClick event hiding an element on the page.
struct Event: Sendable, Hashable, Comparable {
    var name: String
    var actions: [any Action]

    static func == (lhs: Event, rhs: Event) -> Bool {
        rhs.name == lhs.name &&
        rhs.actions.map { $0.compile() } == lhs.actions.map { $0.compile() }
    }

    static func < (lhs: Event, rhs: Event) -> Bool {
        lhs.name < rhs.name
    }

    init(_ type: EventType, actions: [any Action]) {
        self.name = type.rawValue
        self.actions = actions
    }

    init(name: String, actions: [any Action]) {
        self.name = name
        self.actions = actions
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(actions.map { $0.compile() })
    }
}
