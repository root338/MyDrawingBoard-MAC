//
//  ReplaceInfo.swift
//  ReplacePhoneTools
//
//  Created by apple on 2020/9/21.
//  Copyright © 2020 GML. All rights reserved.
//

import Foundation

struct ReplaceInfo : Codable {
    
    private enum CodingKeys: String, CodingKey {
        case url = "path"
        case replaceURL = "replacePath"
        case replaceURLIsDepth = "replacePathIsDepth"
        case urlIsDepth = "pathIsDepth"
    }
    
    let replaceURLIsDepth: Bool
    let urlIsDepth: Bool
    var replaceURL: URL
    var url: URL
    
    init(replaceURL: URL,
         url: URL,
         replaceURLIsDepth: Bool,
         urlIsDepth: Bool) {
        self.replaceURL = replaceURL
        self.url = url
        self.replaceURLIsDepth = replaceURLIsDepth
        self.urlIsDepth = urlIsDepth
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var dic : [CodingKeys: String] = [
            .replaceURLIsDepth : "true",
            .urlIsDepth : "false"
        ]
        for key in container.allKeys {
            let value = try container.decode(String.self, forKey: key)
            dic[key] = value
        }
        self.init(replaceURL: URL(fileURLWithPath: dic[.replaceURL]!),
                  url: URL(fileURLWithPath: dic[.url]!),
                  replaceURLIsDepth: (dic[.replaceURLIsDepth]! as NSString).boolValue,
                  urlIsDepth: (dic[.urlIsDepth]! as NSString).boolValue)
    }
}
