//
//  Blocks.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 08/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

typealias FailureBlock = (errorString: String) -> (Void)
typealias VoidBlock = (Void) -> (Void)
typealias ArrayBlock = (array: NSArray) -> (Void)
typealias StringBlock = (string: String) -> (Void)
typealias DictionaryBlock = (dictionary: NSDictionary) -> (Void)
typealias BoolBlock = (bool: Bool) -> (Void)

typealias UserBlock = (user: User?) -> (Void)
typealias GameBlock = (game: Game?) -> (Void)
typealias PlayerBlock = (player: Player?) -> (Void)
