// borrowed from:
//   https://github.com/apple/swift/blob/4949fcd830cfc287c167c9cdceba410123fa6399/stdlib/public/core/Stride.swift.gyb#L166-L226
// i really have no idea why this was removed.
// it's a pain to implement all this crap for any Strideable type.
extension Strideable {
  public static func + (lhs: Self, rhs: Self.Stride) -> Self {
    return lhs.advanced(by: rhs)
  }

  public static func + (lhs: Self.Stride, rhs: Self) -> Self {
    return rhs.advanced(by: lhs)
  }

  public static func - (lhs: Self, rhs: Self.Stride) -> Self {
    return lhs.advanced(by: -rhs)
  }

  public static func - (lhs: Self, rhs: Self) -> Self.Stride {
    return rhs.distance(to: lhs)
  }

  public static func += (lhs: inout Self, rhs: Self.Stride) {
    lhs = lhs.advanced(by: rhs)
  }

  public static func -= (lhs: inout Self, rhs: Self.Stride) {
    lhs = lhs.advanced(by: -rhs)
  }
}
