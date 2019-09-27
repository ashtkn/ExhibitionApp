import Foundation

protocol Injectable {
    associatedtype Dependency
    var dependency: Dependency! { get set }
}
