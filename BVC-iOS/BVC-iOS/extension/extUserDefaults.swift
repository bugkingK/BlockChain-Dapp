
import Foundation

extension UserDefaults {
    enum UserDefaultsKeys: String {
        case isFirstExcuteIn
        case isLoggedIn
        case phoneNumber
        case isAutu
        case selectedPlaceId
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
    
    func setIsAutu(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isAutu.rawValue)
        synchronize()
    }
    
    func getisAutu() -> Bool {
        return bool(forKey: UserDefaultsKeys.isAutu.rawValue)
    }
    
    func setSelectedPlaceId(value: String) {
        set(value, forKey: UserDefaultsKeys.selectedPlaceId.rawValue)
        synchronize()
    }
    
    func getselectedPlaceId() -> String {
        return string(forKey: UserDefaultsKeys.selectedPlaceId.rawValue)!
    }
}
