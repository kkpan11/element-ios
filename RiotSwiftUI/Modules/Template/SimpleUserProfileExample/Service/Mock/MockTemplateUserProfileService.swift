// 
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import Combine

@available(iOS 14.0, *)
class MockTemplateUserProfileService: TemplateUserProfileServiceProtocol {
    var presenceSubject: CurrentValueSubject<TemplateUserProfilePresence, Never>
    
    let userId: String
    var displayName: String?
    let avatarUrl: String?
    init(
        userId: String = "123",
        displayName:  String? = "Alice",
        avatarUrl: String? = "mx123@matrix.com",
        presence: TemplateUserProfilePresence = .offline
    ) {
        self.userId = userId
        self.displayName = displayName
        self.avatarUrl = avatarUrl
        self.presenceSubject = CurrentValueSubject<TemplateUserProfilePresence, Never>(presence)
    }
    
    func simulateUpdate(presence: TemplateUserProfilePresence) {
        self.presenceSubject.send(presence)
    }
}
