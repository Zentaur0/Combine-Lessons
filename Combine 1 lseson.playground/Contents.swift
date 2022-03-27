import Foundation
import Combine

class CustomSubscription<S: Subscriber>: Subscription {
    
    private var subscriber: S?
    
    init(subscriber: S?) {
        self.subscriber = subscriber
    }
    
    func request(_ demand: Subscribers.Demand) {
        print("subscription requested")
        subscriber?.receive(completion: .finished)
    }
    
    func cancel() {
        print("subscription canceled")
        subscriber = nil
    }
}

// MARK: - 1
struct CustomPublisher<T: Hashable>: Publisher {
    typealias Output = T
    typealias Failure = Never
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, T == S.Input {
        let subscription = CustomSubscription(subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - 2
final class CustomSubscriber<T: Hashable>: Subscriber {
    typealias Input = T
    typealias Failure = Never
    
    func receive(_ input: T) -> Subscribers.Demand {
        print("Receive input: ", input)
        return .unlimited
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Completion received: ", completion)
    }
}
