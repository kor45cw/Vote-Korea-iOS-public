//
//  ElectionInfo.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 23..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import UIKit

class ElectionInfo {
    // 3, 11, 10: 시도 까지만 검색하면 된다
    // 4, 2: 구까지만
    // 5, 6, 10: 구까지 검색하고 두가지이상 있다는 걸 보여줘야할듯

    private static let items = ["국회의원선거": 2,
                 "시·도지사선거": 3,
                 "구·시·군의장선거": 4,
                 "시·도의회의원선거": 5,
                 "구·시·군의회의원선거": 6,
                 "교육의원선거": 10,
                 "교육감선거": 11]
    
    private static let cities = ["서울": "서울특별시", "울산": "울산광역시",
                          "부산": "부산광역시", "경기": "경기도",
                          "대구": "대구광역시", "강원": "강원도",
                          "인천": "인천광역시", "충북": "충청북도",
                          "광주": "광주광역시", "충남": "충청남도",
                          "대전": "대전광역시", "전북": "전라북도",
                          "전남": "전라남도", "경북": "경상북도",
                          "경남": "경상남도", "제주특별자치도": "제주특별자치도", "세종특별자치시": "세종특별자치시"]
    
    private static let geyo = [ElectionData(.title, title: "의의"),
                               ElectionData(.content, title: "교육감/특별시장·광역시장·도지사/구청장·시장·군수/비례대표(특별시·광역시·도의원)/구의원·시의원·군의원/비례대표(구의원·시의원·군의원) 의 선출을 위한 투표"),
                               ElectionData(.title, title: "투표자격"),
                               ElectionData(.content, title: "1999년 6월 14일 이전 탄생자\n(누구나 만 19살이 된 자)"),
                               ElectionData(.title, title: "준비물"),
                               ElectionData(.contentWithTitle, title: "신분증:", subtitle: "주민등록증, 여권, 운전면허, 복지카드(장애인 등록증) 등"),
                               ElectionData(.title, title: "일정"),
                               ElectionData(.contentWithTitle, title: "사전투표:", subtitle: "6월 8일, 6월 9일 (오전 6시부터 오후 6시까지)"),
                               ElectionData(.contentWithTitle, title: "투표:", subtitle: "6월 13일 (오전 6시부터 오후 6시까지)"),
                               ElectionData(.title, title: "주의사항"),
                               ElectionData(.content, title: "신분층 필참\n투표용지 및 기표소 내 촬영금지\n한 장에 한 명의 후보명 옆 칸에 도장찍기"),
                               ElectionData(.image, image: #imageLiteral(resourceName: "imgVote01"))]
    
    private static let sajun = [ElectionData(.title, title: "사전 투표 안내"),
                                ElectionData(.content, title: "선거일에 투표가 불가능할 경우 별도의 신고 없이 전국 어디에서나 사전 투표가 가능합니다. 다만, 내가 사는 곳이 아닌 지역에서 투표하는 경우(관외 투표)에는 투표용지와 함께 회송용 봉투를 받게 됩니다."),
                                ElectionData(.title, title: "일시"),
                                ElectionData(.content, title: "6월 8일과 9일 오전6시부터 오후6시까지"),
                                ElectionData(.title, title: "사전 투표 과정 안내 (관내)"),
                                ElectionData(.image, image: #imageLiteral(resourceName: "imgVotePOut01")), ElectionData(.image, image: #imageLiteral(resourceName: "imgVotePOut02")), ElectionData(.image, image: #imageLiteral(resourceName: "imgVotePOut03")), ElectionData(.image, image: #imageLiteral(resourceName: "imgVotePOut04")), ElectionData(.image, image: #imageLiteral(resourceName: "imgVotePOut05")), ElectionData(.image, image: #imageLiteral(resourceName: "imgVotePOut06"))
                                ]
    
    private static let target = [ElectionData(.title, title: "6월 13일 투표 안내"),
                                 ElectionData(.content, title: "선거일 당일에는 내가 사는 곳에서(선거구 확인) 투표가 가능합니다."),
                                 ElectionData(.title, title: "일시"),
                                 ElectionData(.content, title: "6월 13일 오전6시부터 오후6시까지"),
                                 ElectionData(.title, title: "투표 과정 안내"),
                                 ElectionData(.content, title: "(세종시,제주도, 재보궐선거지역의 경우 투표용지의 갯수가 다름.)"),
                                 ElectionData(.image, image: #imageLiteral(resourceName: "imgVoteday01")), ElectionData(.image, image: #imageLiteral(resourceName: "imgVoteday02")),
                                 ElectionData(.image, image: #imageLiteral(resourceName: "imgVoteday03")), ElectionData(.image, image: #imageLiteral(resourceName: "imgVoteday04")),
                                 ElectionData(.image, image: #imageLiteral(resourceName: "imgVoteday05")), ElectionData(.image, image: #imageLiteral(resourceName: "imgVoteday06")),
                                 ElectionData(.image, image: #imageLiteral(resourceName: "imgVoteday061")), ElectionData(.image, image: #imageLiteral(resourceName: "imgVoteday07")),
                                 ElectionData(.image, image: #imageLiteral(resourceName: "imgVoteday08")),
                                 ]
    
    private static let illjung = [ElectionData(.title, title: "5월 31일"),
                                  ElectionData(.content, title: "선거기간 개시일"),
                                  ElectionData(.title, title: "5월 31일 ~ 6월 12일"),
                                  ElectionData(.content, title: "선거방송토론위원회 주관 대담/토론회 개최"),
                                  ElectionData(.title, title: "6월 1일"),
                                  ElectionData(.content, title: "선거인명부 확정"),
                                  ElectionData(.title, title: "6월 3일 까지"),
                                  ElectionData(.content, title: "투표소의 명칭과 소재지 공고"),
                                  ElectionData(.title, title: "6월 8, 9일 오전 6시 ~ 오후 6시"),
                                  ElectionData(.content, title: "사전 투표"),
                                  ElectionData(.title, title: "6월 13일 오전 6시 ~ 오후 6시"),
                                  ElectionData(.content, title: "투표"),]
    
    private static let jaju = [ElectionData(.title, title: "투표 인증샷이 가능한가요?"),
                               ElectionData(.content, title: "가능합니다.\n공직선거법의 개정으로 손가락 등을 이용하여 지지 후보의 기호 등을 표기한 사진을 전송 혹은 게시할 수 있으며, 뿐만 아니라 (엑스자 등의 포즈를 취하고)벽보 앞에서 사진을 찍는 것도 가능합니다.\n하지만 벽보의 훼손, 기표함 내에서의 촬영, 투표용지의 촬영 등은 허용되지 않습니다."),
                               ElectionData(.title, title: "투표소 앞에서 지지하는 후보를 밝힐 수 있나요?"),
                               ElectionData(.content, title: "투표소 반경 100m 내에서는 소란을 피우거나 특정 후보를 지지/반대하는 행위가 금지됩니다."),
                               ElectionData(.title, title: "선거와 관련된 의견을 SNS 등에 게시하여도 될까요?"),
                               ElectionData(.content, title: "가능합니다.\n선거운동을 할 수 있는 사람이 인터넷\n홈페이지에 글을 올리거나 문자메시지(자동 동보통신의 방법제외)를 전송하는 방법으로 선거운동을 하는 것은 항상 허용됩니다.\n(공직선거법, 제59조 제2호,제3호 참조)\n(*자동 동보통신이란? 프로그램 등을 이용하여 자동으로 다수에게 전송하는 행위)\n다만 후보자에 대한 허위사실 유포, 비방 등은 처벌받을 수 있습니다. 또한 이를 댓가로 금품을 제공받거나 후보자를 사칭하여 글을 올려서는 안됩니다."),
                               ElectionData(.title, title: "기타 안내"),
                               ElectionData(.content, title: "위 문답은 참고용으로, 자세하고 정확한 내용은 1390 (선거콜센터) 혹은 중앙선거관리위원회로 확인하시기 바랍니다."),]
    
    open static func electionInfo(_ type: Int) -> [ElectionData] {
        switch type {
        case 0:
            return geyo
        case 1:
            return sajun
        case 2:
            return target
        case 3:
            return illjung
        case 4:
            return jaju
        default:
            return []
        }
    }
    
    open static func getAllItems() -> Dictionary<String, Int> {
        return items
    }
    
    open static func findCode(_ name: String) -> Int {
        return items[name] ?? 0
    }
    
    open static func findName(_ code: Int) -> String {
        for item in items  {
            if item.value == code {
                return item.key
            }
        }
        return ""
    }
    
    open static func matchCity(_ city: String) -> String {
        return cities[city] ?? ""
    }
}

enum ElectionDataType {
    case title
    case content
    case image
    case contentWithTitle
    case none
}

struct ElectionData {
    var type: ElectionDataType = .none
    var title = ""
    var subtitle = ""
    var contentImage: UIImage? = nil
    
    init(_ type: ElectionDataType, title: String = "", subtitle: String = "", image: UIImage? = nil) {
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.contentImage = image
    }
}
