//
//  UsersEnitity.swift
//  JsonFetchWithCoreData
//
//  Created by Nilesh Vernekar on 07/09/21.
//

import Foundation

class UserDic:NSObject, Codable {
    var userarray : [UserDataModel]?
}
class UserDataModel: Codable {
    var id: Int?
    var name, username, email: String?
    var address: Address?
    var phone, website: String?
    var company: Company?

}

// MARK: - exAddress
class Address: Codable {
    var street, suite, city, zipcode: String?
    var geo: Geo?


}

// MARK: - exGeo
class Geo: Codable {
    let lat, lng: String?

}

// MARK: - exCompany
class Company: Codable {
    let name, catchPhrase, bs: String?

}


