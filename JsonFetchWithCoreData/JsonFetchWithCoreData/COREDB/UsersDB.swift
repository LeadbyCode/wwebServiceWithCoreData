//
//  UsersDB.swift
//  JsonFetchWithCoreData
//
//  Created by Nilesh Vernekar on 07/09/21.
//

import Foundation

class UsersDB: NSObject {
    
    
private var cacheManager: CacheManager?
   
   init(modelName: String,entityName: String) {
       cacheManager = CacheManager(modelName: modelName, entityName: entityName)
   }
    
      func readNotesFromCache<T: Codable>() -> T? {
         
        if let usersList: [UserModel] = cacheManager?.retrieveData() {
             if let notesModel = usersList.first {
                 do {
                     return try JSONDecoder().decode(T.self, from: notesModel.data ?? Data())
                 } catch _ {
                     return nil
                 }
             }
             
         }
         return nil
     }
    fileprivate func insertNotes(ListModel: UserDic) -> Bool {
           let encoder =  JSONEncoder()
           
           do {
               let cache = UserModel(context: (cacheManager?.getManagedObject())!)
               let data = try encoder.encode(ListModel)
               cache.data = data
               
               return cacheManager?.saveContextIfChanged() == true ? true : false
           } catch {
               return false
           }
       }
    
    func updateNotes<T: Codable>(model: T) -> Bool {
          if let notes: [UserModel] = cacheManager?.retrieveData() {
              if let notesModel = notes.first {
                  let encoder = JSONEncoder()
                  do {
                      let data = try encoder.encode(model)
                      notesModel.data = data
                      
                      return cacheManager?.saveContextIfChanged() == true ? true : false
                  } catch {
                      return false
                  }
              }
              
          }
          return false
      }
    func createnote(ListModel: UserDic) -> Bool {
         if let notes: [UserModel] = cacheManager?.retrieveData() {
             if notes.count > 0 {
                 return self.updateNotes(model:ListModel)
             } else {
                 return self.insertNotes(ListModel: ListModel)
             }
         } else {
            return self.insertNotes(ListModel: ListModel)
         }
         
     }
}
struct ConstantsStrings {
    static let xcdatamodeld = "JsonFetchWithCoreData"
    static let modelEntity = "UserModel"
}
