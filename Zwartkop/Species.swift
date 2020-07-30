import Foundation

enum Species {
    case id(String)  // 4 upper-case ASCII letters -- unique!
    case name(String)  // if unknown, use this instead
}

extension Species: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (let id(id1),     let id(id2)):     return id1 == id2
        case (let name(name1), let name(name2)): return name1 == name2
        case (let id(id),      let name(name)):  return id == name2id[name]
        case (let name(name),  let id(id)):      return id == name2id[name]
        }
    }
}

extension Species: Hashable { }

extension Species {
    var name: String? {
        switch self {
        case .id(let s):   return id2name[s]
        case .name(let s): return s
        }
    }

    var id: String? {
        switch self {
        case .id(let s):   return s
        case .name(let s): return name2id[s]
        }
    }
}

extension Species {
    var isKnown: Bool {
        switch self {
        case .id(let s):   return id2name.keys.contains(s)
        case .name(let s): return name2id.keys.contains(s)
        }
    }
}

extension Species {
    static var all: Set<Species> {
        return Set(id2name.keys.map({ Species.id($0) }))
    }
}

// INTERNAL JUNK:

private var id2name: [String: String] = {
    var _id2name: [String: String] = [:]

    let url = Bundle.main.url(forResource: "Species", withExtension: "properties")!
    let text = try! String(contentsOf: url)
    text.enumerateLines(invoking: { (line, stop) in
        let stripped = line.trimmingCharacters(in: .whitespaces)
        if stripped.hasPrefix("#") || stripped.isEmpty {
            return
        }

        let parts = stripped.split(separator: "=", maxSplits: 1)
        let id = parts[0].trimmingCharacters(in: .whitespaces)
        let name = parts[1].trimmingCharacters(in: .whitespaces)

        _id2name[id] = name
        name2id[name] = id
    })

    return _id2name
}()

private var name2id: [String: String] = [:]
