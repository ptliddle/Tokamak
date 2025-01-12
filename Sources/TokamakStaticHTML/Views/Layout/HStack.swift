// Copyright 2020 Tokamak contributors
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

import TokamakCore

extension VerticalAlignment {
  var cssValue: String {
    switch self {
    case .top:
      return "start"
    case .center:
      return "center"
    case .bottom:
      return "end"
    }
  }
}

extension HStack: _HTMLPrimitive, SpacerContainer {
  public var axis: SpacerContainerAxis { .horizontal }

  @_spi(TokamakStaticHTML)
  public var renderedBody: AnyView {
    AnyView(HTML("div", [
      "style": """
      display: flex; flex-direction: row; align-items: \(alignment.cssValue);
      \(hasSpacer ? "width: 100%;" : "")
      \(fillCrossAxis ? "height: 100%;" : "")
      """,
      "class": "_tokamak-stack",
    ]) { content })
  }
}
