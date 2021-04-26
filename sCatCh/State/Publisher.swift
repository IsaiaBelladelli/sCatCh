
import Combine
import SwiftUI

struct TimePublisher {

    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private var subscriptions = [AnyCancellable]()
     
    init(every interval: Int){
        timer = Timer.publish(every: TimeInterval(interval), on: .main, in: .common).autoconnect()
    }
    
    func getTimer() -> Publishers.Autoconnect<Timer.TimerPublisher> { timer }
    
    mutating func subscribe(action: @escaping () -> ()) {
        timer
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {_ in action() } )
            .store(in: &subscriptions)
    }
    
    func unsubscribe() {
        for subscription in subscriptions {
            subscription.cancel()
        }
    }
}
