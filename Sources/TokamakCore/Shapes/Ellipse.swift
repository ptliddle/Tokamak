// Copyright 2020-2021 Tokamak contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//  Created by Carson Katri on 6/29/20.
//

import Foundation

public struct Ellipse: Shape {
  public func path(in rect: CGRect) -> Path {
    .init(storage: .ellipse(rect), sizing: .flexible)
  }

  public init() {}
}

public struct Circle: Shape {
  public func path(in rect: CGRect) -> Path {
    .init(storage: .ellipse(rect), sizing: .flexible)
  }

  public init() {}
}

public struct Capsule: Shape {
  public var style: RoundedCornerStyle

  public init(style: RoundedCornerStyle = .circular) {
    self.style = style
  }

  public func path(in rect: CGRect) -> Path {
    .init(
      storage: .roundedRect(.init(
        capsule: rect,
        style: style
      )),
      sizing: .flexible
    )
  }
}
