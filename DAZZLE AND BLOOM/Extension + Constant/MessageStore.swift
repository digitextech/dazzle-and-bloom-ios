//
//  MessageStore.swift
//  ChatSample
//
//  Created by Hafiz on 20/09/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import Foundation

struct MessageStore {
    static func getAll() -> [ListMessage] {
        return [
            ListMessage(text: "Lorem ipsum dolor sit amet", side: .left),
            ListMessage(text: "Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", side: .left),
            ListMessage(text: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae", side: .right),
            ListMessage(text: "Excepteur sint occaecat cupidatat non proident", side: .left),
            ListMessage(text: "Sed ut perspiciatis", side: .right),
            ListMessage(text: "qui dolorem ipsum quia dolor sit amet, consectetur", side: .left),
            ListMessage(text: "Vel illum qui dolorem eum fugiat", side: .right),
            ListMessage(text: "At vero eos et accusamus et iusto odio dignissimos", side: .left),
            ListMessage(text: "Et harum quidem rerum facilis", side: .right),
            ListMessage(text: "Lorem ipsum dolor sit amet", side: .left),
            ListMessage(text: "Vel illum qui dolorem eum fugiat", side: .left),
            ListMessage(text: "Lorem ipsum", side: .left),
            ListMessage(text: "Lorem ipsum", side: .right),
            ListMessage(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", side: .right),
            ListMessage(text: "Et harum quidem rerum facilis", side: .right),
        ]
    }
}
