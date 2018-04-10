
import Foundation
import Result

// MARK:- Deserializer

protocol APIResponseDeserializer {
    associatedtype Value
    func deserialize(data: Data?) -> Result<Value, NSError>
}


final class APIResponseDeserializerThunk<T>: APIResponseDeserializer {
    typealias Value = T
    private let _deserialize: ((Data?) -> Result<T, NSError>)

    required init<U: APIResponseDeserializer>(_ deserializer: U) where U.Value == T {
        _deserialize = deserializer.deserialize
    }

    func deserialize(data: Data?) -> Result<T, NSError> {
        return _deserialize(data)
    }
}

/**
 In Case you don't want any deserlialization, but just want get pure data.
*/

struct APIResponsePureDeserializer: APIResponseDeserializer {
    func deserialize(data: Data?) -> Result<Data?, NSError> {
        return .success(data)
    }
}
