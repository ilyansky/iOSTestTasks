import Foundation

final class ViewModel {
    let model = Model()
    
    func getChildrenCount() -> Int {
        return model.childrenCount
    }
    
    func incrementChildrenCount() {
        model.childrenCount += 1
    }
    
    func decrementChildrenCount() {
        model.childrenCount -= 1
    }
    
    func clear() {
        model.childrenCount = 0
    }
}
