public extension Bool {
    init?<T: BinaryInteger>(bit: T) {
        switch bit {
        case 0:
            self = false
        case 1:
            self = true
        default:
            return nil
        }
    }
}
