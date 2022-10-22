//
//  ResponsableStatus.swift
//  lines_iOS
//
//  Created by mun on 2022/09/11.
//

struct LoginResponse: Codable {
    let accessToken: String?
    let refreshToken: String?
    let isCreated: Bool?
}

struct LogoutResponse: Codable {
    
}
struct CardInfoList: Codable {
    let number: Int
    let content: [CardInfoContent]
    let pageable: Pageable
    let sort: Sort
    let numberOfElements, totalPages, size: Int
    let last, empty: Bool
    let totalElements: Int
    let first: Bool
}

struct CardInfoContent: Codable {
    let id: Int
    let content: String
    let bookResponse: BookInfo?
    let ratio, background: String
}

struct BookInfo: Codable {
    let title, name, isbn: String
}

struct Pageable: Codable {
    let sort: Sort
    let offset, pageNumber, pageSize: Int
    let paged, unpaged: Bool
}

struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}

struct SaveCardResponse: Codable {
    let id: Int
    let ratio, background, content: String
    let bookResponse: BookInfo
}
