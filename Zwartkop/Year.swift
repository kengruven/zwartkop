/// In normal programs, you just define "year:Int" and call it a day.
/// Dendrochronology is special because (a) crossing the BC/AD boundary is not uncommon,
/// and (b) we often deal in relative years.
///
/// By convention,
///  - For unknown samples, by convention, we start at year 1001
///  - When we print data in a table, it's 10 years per row, with columns "0" to "9" (last digit of year)
///  - The year before 1AD is 1BC, but we leave a gap in tables/charts, so for example
///    the space on a chart from 40BC to 20BC is the same as the space between 10BC to 10AD,
///    and the value for 1BC in a table occurs in the 10th column, not the 1st column.
///
/// The "gap" is rather counterintuitive, so it may be desirable to make this a user preference.
/// (It's really only exposed in the row/col extension.)
struct Year {
    let value: Int  // (but no 0 allowed!)
    let isAbsolute: Bool  // any operations with multiple Years only make sense if both are absolute, or both are relative!

    init(_ value: Int, isAbsolute: Bool) {
        precondition(value != 0, "expected non-zero value")
        self.value = value
        self.isAbsolute = isAbsolute
    }

    static let `default` = Year(1001, isAbsolute: false)
}

// (no idea why i might need this, but it can't hurt)
extension Year: Hashable { }

extension Year: Equatable { }

extension Year: Comparable {
    static func < (lhs: Year, rhs: Year) -> Bool {
        precondition(lhs.isAbsolute == rhs.isAbsolute)
        return lhs.value < rhs.value
    }
}

extension Year: Strideable {
    // convert to/from "int" = integers without gap at 0.
    // FUTURE: expose this interface somehow?
    private static func y2i(_ v: Int) -> Int {
        return v > 0 ? v : v + 1
    }
    private static func i2y(_ v: Int) -> Int {
        return v <= 0 ? v - 1 : v
    }

    func distance(to other: Year) -> Int {
        precondition(self.isAbsolute == other.isAbsolute)
        return Year.y2i(self.value) - Year.y2i(other.value)
    }

    func advanced(by n: Int) -> Year {
        return Year(Year.i2y(Year.y2i(self.value) + n),
                    isAbsolute: isAbsolute)
    }
}

extension Year: CustomStringConvertible {
    // (note: no isAbsolute indicator in this string)
    var description: String {
        // TODO?: should <0 values have a '-'?
        return String(value)
    }
}

extension Year {
    // row=0 is 1...9 (only row with 9 years), row 1 is 10...19, row 2 is 20...29, etc.
    var row: Int {
        if value < 0 {
            return (value + 1) / 10 - 1
        } else {
            return value / 10
        }
    }

    // col is 0 through 9
    var col: Int {
        if value < 0 {
            return 10 - ((10 - value) % 10)
        } else {
            return value % 10
        }
    }
}
