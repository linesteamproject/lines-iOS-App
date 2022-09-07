//
//  RealmController.swift
//  lines_iOS
//
//  Created by mun on 2022/09/01.
//

import RealmSwift

class RealmController {
    static let shared = RealmController()
    internal let queue = DispatchQueue(label: "RealmQueue")
    private let realm = try! Realm()
    internal func write(_ obj: CardModel_Realm, done: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            try? self.realm.write {
                self.realm.add(obj)
                done?()
            }
        }
    }
    
    func getBookCards(done: (([CardModel?]) -> Void)?) {
        DispatchQueue.main.async {
            let models = Array(self.realm.objects(CardModel_Realm.self).compactMap {
                return $0.getCardModel()
            })
            done?(models.reversed())
        }
    }
}
