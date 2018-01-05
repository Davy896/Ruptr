//
//  PromptViewDelegate.swift
//  App
//
//  Created by Lucas Assis Rodrigues on 05/01/2018.
//  Copyright © 2018 Apple Dev Academy. All rights reserved.
//

import Foundation

@objc protocol PromptViewDelegate {
    @objc func dismissInvitationPrompt(_ sender: RoundButton)
}
