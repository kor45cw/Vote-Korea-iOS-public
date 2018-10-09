//
//  NetworkManager.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 21..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import RealmSwift
import XMLMapper
import AlamofireObjectMapper
import Alamofire

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}


class NetworkManager {
    func getVoteLocation(_ sdName: String, handler: @escaping ([VoteLocation]?) -> Void) {
        Alamofire.request(URL(string: "https://teamneko.io/votekorea/search_api/preVote/\(sdName.urlEscaped)")!)
            .responseArray(keyPath: "data") { (response: DataResponse<[VoteLocation]>) in
                if let result = response.result.value {
                    handler(result)
                } else {
                    print("error")
                    handler(nil)
                }
            }
    }
    
    func getVoteLocationDday(_ sdName: String, handler: @escaping ([VoteLocation]?) -> Void) {
        Alamofire.request(URL(string: "https://teamneko.io/votekorea/search_api/ddVote/\(sdName.urlEscaped)")!)
            .responseArray(keyPath: "data") { (response: DataResponse<[VoteLocation]>) in
                if let result = response.result.value {
                    handler(result)
                } else {
                    print("error")
                    handler(nil)
                }
        }
    }
    
    func getLocationAlertText(handler: @escaping (String?) -> Void) {
        Alamofire.request(URL(string: "https://teamneko.io/json/votekorea/vote_placeTXT.json")!)
            .responseJSON { (response) in
                if let responseJSON = response.result.value as? [String: Any],
                let data = responseJSON["data"] as? [Any], let data2 = data[0] as? [String: String] {
                    handler(data2["text"])
                } else {
                    handler(nil)
                }
        }
    }
    
    func getCityInfo(_ electionCode: Int, completion: @escaping ([CityInfo]?) -> Void) {
        let parameter: Parameters = ["electionId": "0020180613",
                                     "electionCode": electionCode]
        
        Alamofire.request(URL(string: "http://info.nec.go.kr/bizcommon/selectbox/selectbox_cityCodeBySgJson.json")!,
                          method: .get, parameters: parameter,
                          encoding: URLEncoding.default, headers: nil)
            .responseArray(keyPath: "jsonResult.body") { (response: DataResponse<[CityInfo]>) in
                if let result = response.result.value {
                    completion(result)
                } else {
                    print("error")
                    completion(nil)
                }
        }
    }
    
    func getCandidateDetail(_ huboid: Int, handler: @escaping (CandidateDetailInfo?) -> Void) {
        Alamofire.request(URL(string: "https://teamneko.io/votekorea/search_api/huboID/\(huboid)")!)
            .responseObject(keyPath: "data") { (response: DataResponse<CandidateDetailInfo>) in
                if let result = response.result.value {
                    do {
                        let realm = try Realm()
                        let predicate = NSPredicate(format: "huboid == \(huboid)")
                        let data = realm.objects(CandidateInfo.self).filter(predicate).first
                        try realm.write {
                            if let data = data {
                                data.imagePath = result.imagePath
                            }
                            realm.add(result, update: true)
                        }
                    } catch let error as NSError {
                        print("Handle \(error)")
                    }
                    handler(result)
                } else {
                    print("getCandidateDetail", "error")
                    handler(nil)
                }
        }
    }
    
    
    func getsggJungsu(_ sgTypecode: Int, filter: String, handler: @escaping (Int?) -> Void) {
        Alamofire.request(URL(string: "http://apis.data.go.kr/9760000/CommonCodeService/getCommonSggCodeList?sgId=20180613&sgTypecode=\(sgTypecode)&pageNo=1&numOfRows=10000&serviceKey=")!)
            .responseXMLArray(keyPath: "body.items.item") { (response: DataResponse<[SggCode]>) in
                if let result = response.result.value {
                    if let item = result.filter({$0.sggName == filter}).first {
                        handler(item.sggJungsu)
                    } else {
                        handler(nil)
                    }
                } else {
                    print("error", response.error.debugDescription)
                    handler(nil)
                }
        }
    }
    
    func getResult(type: Int, completion: @escaping ([CandidateInfo]?) -> Void) {
        Alamofire.request(URL(string: "http://apis.data.go.kr/9760000/PofelcddInfoInqireService/getPofelcddRegistSttusInfoInqire?sgId=20180613&sgTypecode=\(type)&pageNo=1&numOfRows=10000&serviceKey=")!,
                          method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseXMLArray(keyPath: "body.items.item") { (response: DataResponse<[CandidateInfo]>) in
                if let result = response.result.value {
                    DispatchQueue(label: "background").async {
                        do {
                            let realm = try Realm()
                            try realm.write {
                                realm.add(result, update: true)
                            }
                        } catch let error as NSError {
                            print("Handle \(error)")
                        }
                        completion(result)
                    }
                } else {
                    print("error", response.error.debugDescription)
                    completion(nil)
                }
        }
    }
    
    func getPDF(_ huboid: Int, gubun: Int, handler: @escaping ([PDFInfo]?) -> Void) {
        Alamofire.request(URL(string: "http://info.nec.go.kr/electioninfo/candidate_detail_scanSearchJson.json?statementId=CPRI03_candidate_scanSearch&electionId=0020180613&huboId=\(huboid)&gubun=\(gubun)")!)
            .responseArray(keyPath: "jsonResult.body") { (response: DataResponse<[PDFInfo]>) in
                if let result = response.result.value {
                    handler(result)
                } else {
                    print("error")
                    handler(nil)   
                }
        }
    }
    
    func getCityCode(handler: @escaping ([CityInfo]?) -> Void) {
        let parameter: Parameters = ["electionId": "0020180613",]
        Alamofire.request(URL(string: "http://info.nec.go.kr/bizcommon/selectbox/selectbox_cityCodeBySgJson.json")!,
                        method: .get, parameters: parameter, encoding: URLEncoding.default, headers: nil)
            .responseArray(keyPath: "jsonResult.body") { (response: DataResponse<[CityInfo]>) in
                if let result = response.result.value {
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(result, update: true)
                        }
                    } catch let error as NSError {
                        print("Handle \(error)")
                    }
                    handler(result)
                } else {
                    print("getCityCode", "error")
                    handler(nil)
                }
        }
    }
    
    func getTownCode(_ city: Int, handler: @escaping ([CityInfo]?) -> Void) {
        let parameter: Parameters = ["electionId": "0020180613",
                                     "cityCode": city]
        Alamofire.request(URL(string: "http://info.nec.go.kr/bizcommon/selectbox/selectbox_townCodeJson.json")!,
                          method: .get, parameters: parameter, encoding: URLEncoding.default, headers: nil)
            .responseArray(keyPath: "jsonResult.body") { (response: DataResponse<[CityInfo]>) in
                if let result = response.result.value {
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(result, update: true)
                        }
                    } catch let error as NSError {
                        print("Handle \(error)")
                    }
                    handler(result)
                } else {
                    print("getCityCode", "error")
                    handler(nil)
                }
        }
    }
    
    func getEndTown(_ electionCode: Int, cityCode: Int, handler: @escaping ([EndTown]?) -> Void) {
        let url = "http://info.nec.go.kr/m/electioninfo/electionInfo_report.json?electionId=0020180613&electionCode=\(electionCode)&cityCode=\(cityCode)&statementId=BIGI05&dateCode=0"
        Alamofire.request(URL(string: url)!)
            .responseArray(keyPath: "jsonResult.body") { (response: DataResponse<[EndTown]>) in
                if let result = response.result.value {
                    handler(result)
                } else {
                    print("getEndTown", "error")
                    handler(nil)
                }
        }
    }
    
    
    func getAddress(_ keyword: String, handler: @escaping ([AddressInfo]?) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "KakaoAK 4ae14ebc9755d157fd3e0b93c91fdaab"]
        let parameters: Parameters = ["query": keyword, "size": 30]
        Alamofire.request(URL(string: "https://dapi.kakao.com/v2/local/search/address.json")!,
                            method: .get, parameters: parameters,
                            encoding: URLEncoding.default, headers: headers)
        .responseArray(keyPath: "documents.address") { (response: DataResponse<[AddressInfo]>) in
            if let result = response.result.value {
                handler(result.uniqueValues { $0 })
            } else {
                print("error")
                handler(nil)
            }
        }
    }
    
    func getAddressRoad(_ keyword: String, handler: @escaping ([AddressInfo]?) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "KakaoAK 4ae14ebc9755d157fd3e0b93c91fdaab"]
        let parameters: Parameters = ["query": keyword, "size": 30]
        Alamofire.request(URL(string: "https://dapi.kakao.com/v2/local/search/address.json")!,
                          method: .get, parameters: parameters,
                          encoding: URLEncoding.default, headers: headers)
            .responseArray(keyPath: "documents.road_address") { (response: DataResponse<[AddressInfo]>) in
                if let result = response.result.value {
                    handler(result.uniqueValues { $0 })
                } else {
                    print("error")
                    handler(nil)
                }
        }
    }
    
    
    func getCoor(_ query: String, handler: @escaping (CoordiateInfo?) -> Void) {
        let headers: HTTPHeaders = ["X-Naver-Client-Id": "PxvzvLaLbNULXv4Pf8sz",
                                    "X-Naver-Client-Secret": "po8SS340ru"]
        
        Alamofire.request(URL(string: "https://openapi.naver.com/v1/map/geocode?query=\(query.urlEscaped)")!,
                          method: .get, parameters: nil,
                          encoding: URLEncoding.default, headers: headers)
            .responseArray(keyPath: "result.items") { (response: DataResponse<[CoordiateInfo]>) in
                if let result = response.result.value, !result.isEmpty {
                    print(result[0].posX)
                    print(result[0].posY)
                    handler(result[0])
                } else {
                    print("error")
                    handler(nil)
                }
        }
        
    }
}
