//
//  UIKitControlComponent.swift
//  Gluon
//
//  Created by Max Desiatov on 05/12/2018.
//

import Gluon
import UIKit

public protocol UIKitControlComponent: UIKitHostComponent, HostComponent
  where Props: EventHandlerProps {
  associatedtype Target: UIControl & Default

  static func update(_ view: Target, _ props: Props, _ children: Children)
}

extension UIKitControlComponent {
  public static func bind(handlers: [Event: Handler<()>],
                          for target: ControlWrapper<Target>)
    -> ControlWrapper<Target> {
    var target = target

    for (e, h) in handlers {
      target.bind(to: e, handler: h.value)
    }

    return target
  }
}

extension UIKitControlComponent {
  public static func mountTarget(to parent: Any,
                                 props: AnyEquatable,
                                 children: AnyEquatable) -> Any? {
    guard let children = children.value as? Children else {
      childrenAssertionFailure()
      return nil
    }

    guard let props = props.value as? Props else {
      propsAssertionFailure()
      return nil
    }

    let target = Target()
    update(target, props, children)

    switch parent {
    case let stackView as UIStackView:
      stackView.addArrangedSubview(target)
    case let view as UIView:
      view.addSubview(target)
    default:
      parentAssertionFailure()
    }

    return bind(handlers: props.handlers, for: ControlWrapper(target))
  }

  public static func update(target: Any,
                            props: AnyEquatable,
                            children: AnyEquatable) {
    guard let target = target as? ControlWrapper<Target> else {
      targetAssertionFailure()
      return
    }
    guard let children = children.value as? Children else {
      childrenAssertionFailure()
      return
    }
    guard let props = props.value as? Props else {
      propsAssertionFailure()
      return
    }

    update(target.value, props, children)
  }

  public static func unmount(target: Any) {
    guard let target = target as? ControlWrapper<Target> else {
      targetAssertionFailure()
      return
    }

    target.value.removeFromSuperview()
  }
}