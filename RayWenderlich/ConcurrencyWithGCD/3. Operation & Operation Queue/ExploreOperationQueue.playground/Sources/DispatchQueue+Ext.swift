import Foundation

private extension DispatchQueue {
    struct QueueReference {
        let queue: DispatchQueue
    }
    
    static var key: DispatchSpecificKey<QueueReference> = {
        let key = DispatchSpecificKey<QueueReference>()
        
        return key;
    }()
    
    func setSystemQueuesDetection(key: DispatchSpecificKey<QueueReference>) {
        let systemQueues: [DispatchQueue] = [
            .main,
            .global(qos: .userInteractive),
            .global(qos: .userInitiated),
            .global(),
            .global(qos: .utility),
            .global(qos: .background),
            .global(qos: .unspecified)
        ]
        
        systemQueues.forEach { queue in
            queue.setSpecific(key: key, value: QueueReference(queue: queue))
        }
    }
}

public extension DispatchQueue {
    static var current: DispatchQueue? { DispatchQueue.getSpecific(key: key)?.queue }
    static var currentQOSClass: DispatchQoS.QoSClass? { current?.qos.qosClass }
}
