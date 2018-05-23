
import Foundation

extension UserDefaults {
    enum UserDefaultsKeys: String {
        case isFirstExcuteIn
        case isLoggedIn
    }
    
    func setisFirstExcuteIn(value: Bool){
        set(value, forKey: UserDefaultsKeys.isFirstExcuteIn.rawValue)
        synchronize()
    }
    
    func isFirstExcuteIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isFirstExcuteIn.rawValue)
    }
    
    func setIsLoggedIn(value: Bool){
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
}
