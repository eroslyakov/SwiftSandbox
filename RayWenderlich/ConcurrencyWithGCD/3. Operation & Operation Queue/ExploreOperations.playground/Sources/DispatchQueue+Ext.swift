import Foundation

//MARK: - private implementation

private extension DispatchQueue {
    
    struct QueueReference {
        var queue: DispatchQueue?
    }
    
    static let key: DispatchSpecificKey<QueueReference> = {
        let key = DispatchSpecificKey<QueueReference>()
        setupSystemQueuesDetection(key: key)
        return key
    }()
    
    static func setupSystemQueuesDetection(key: DispatchSpecificKey<QueueReference>) {
        let systemQueues: [DispatchQueue] = [
            .main,
            .global(qos: .userInteractive),
            .global(qos: .userInitiated),
            .global(),
            .global(qos: .utility),
            .global(qos: .background),
            .global(qos: .unspecified)
        ]
        
        setQueuesDetection(queues: systemQueues, for: key)
    }
    
    static func setQueuesDetection(queues: [DispatchQueue], for key: DispatchSpecificKey<QueueReference>) {
        queues.forEach { $0.setSpecific(key: key, value: QueueReference(queue: $0)) }
    }
}

//MARK: - public interface

public extension DispatchQueue {
    
    static var current: DispatchQueue? { DispatchQueue.getSpecific(key: key)?.queue }
    
    static var currentQOSClass: DispatchQoS.QoSClass? { current?.qos.qosClass }
    
    static func setPrivateQueueDetection(_ privateQueue: DispatchQueue) {
        setQueuesDetection(queues: [privateQueue], for: key)
    }
}
