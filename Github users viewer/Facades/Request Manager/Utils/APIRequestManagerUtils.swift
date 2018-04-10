
import Foundation
import ReactiveSwift

extension APIRequestsManager {

    func sendRequest<Value, U:APIResponseDeserializer>(requestProvider: APIRequestProvider, deserializer:U) -> SignalProducer<Value, NSError> where U.Value == Value {
        let requestObject = requestProvider.provideRequest()
        let signal = _makeRequestSignal(requestObject: requestObject, deserializer: deserializer)

        return signal.flatMapError { [weak self] error -> SignalProducer<Value, NSError> in

            print("Response error == \(error.code)")
            return SignalProducer(error: error)
        }
    }


    private func _makeRequestSignal<Value, U:APIResponseDeserializer>(requestObject:Request, deserializer:U) -> SignalProducer<Value, NSError> where U.Value == Value {

        let request = requestObject

        return SignalProducer { [weak self] observer, disposable in
            let task = self?.serviceManager.request(requestObject: request) { result in
                switch result {
                case .success(let response):
                    let object = deserializer.deserialize(data: response.value)
                    switch object {
                    case .success(let response):
                        observer.send(value: response)
                        observer.sendCompleted()
                    case .failure(let responseError):
                        observer.send(error: responseError)
                    }
                case .failure(let responseError):
                    observer.send(error: responseError.error)
                }
            }

            disposable.observeEnded {
                task?.cancel()
            }
        }
    }

}
