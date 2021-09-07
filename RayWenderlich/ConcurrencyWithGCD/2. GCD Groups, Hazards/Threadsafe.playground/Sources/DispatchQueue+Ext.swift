import Foundation

extension DispatchQueue {
    
    private struct QueueReference {
        weak var queue: DispatchQueue?
    }
    
    static private var key: DispatchSpecificKey<QueueReference> {
        let key = DispatchSpecificKey<QueueReference>()
        specifySystemDefinedQueues(with: key)
        return key
    }
    
    static private func _referenceQueues(queues: [DispatchQueue], key: DispatchSpecificKey<QueueReference>) {
        queues.forEach { $0.setSpecific(key: key, value: QueueReference(queue: $0)) }
    }
    
    static private func specifySystemDefinedQueues(with key: DispatchSpecificKey<QueueReference>) {
        let systemQueues: [DispatchQueue] = [
            .main,
            .global(qos: .userInitiated),
            .global(qos: .userInteractive),
            .global(),
            .global(qos: .utility),
            .global(qos: .background),
            .global(qos: .unspecified)
        ]
        
        _referenceQueues(queues: systemQueues, key: key)
    }
}

//MARK: - Public Interface

public extension DispatchQueue {
    
    static var current: DispatchQueue? { getSpecific(key: key)?.queue }
    
    static func referenceQueue(_ queue: DispatchQueue) {
        _referenceQueues(queues: [queue], key: key)
    }
}
