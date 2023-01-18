//
//  Message.swift
//  ChatSample
//
//  Created by Hafiz on 20/09/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import Foundation

enum MessageSide {
    case left
    case right
}

struct ListMessage {
    var text = ""
    var side: MessageSide = .right
}
