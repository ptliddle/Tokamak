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
//
//  Created by Carson Katri on 6/29/20.
//

import TokamakCore

protocol ShapeAttributes {
  func attributes(_ style: ShapeStyle) -> [HTMLAttribute: String]
}

extension _StrokedShape: ShapeAttributes {
  func attributes(_ style: ShapeStyle) -> [HTMLAttribute: String] {
    if let color = style as? Color {
      return ["style": "stroke: \(color.cssValue(environment)); fill: none;"]
    } else {
      return ["style": "stroke: black; fill: none;"]
    }
  }
}

extension _ShapeView: _HTMLPrimitive {
  @_spi(TokamakStaticHTML)
  public var renderedBody: AnyView {
    let path = shape.path(in: .zero).renderedBody
    let attributes: [HTMLAttribute: String]

    if let shapeAttributes = shape as? ShapeAttributes {
      attributes = shapeAttributes.attributes(style)
    } else if let color = style as? Color {
      attributes = ["style": "fill: \(color.cssValue(environment));"]
    } else if let foregroundColor = foregroundColor {
      attributes = ["style": "fill: \(foregroundColor.cssValue(environment));"]
    } else {
      return path
    }

    if let view = mapAnyView(path, transform: { (html: HTML<AnyView>) -> AnyView in
      let uniqueKeys = { (first: String, second: String) in "\(first) \(second)" }
      let mergedAttributes = html.attributes.merging(
        attributes,
        uniquingKeysWith: uniqueKeys
      )
      return AnyView(HTML(html.tag, mergedAttributes) { html.content })
    }) {
      return view
    } else {
      return path
    }
  }
}
