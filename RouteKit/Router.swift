import UIKit


/// A type representing a route
public protocol RouteType { }

extension String: RouteType { }


/// A router is routes from a view controller of type `SourceViewController`
/// to a route of type `Route`.
public protocol RouterType {
    associatedtype Route: RouteType
    associatedtype Source
    
    func route(to route: Route, source: Source)
}


public protocol ContextualRouterType: RouterType {
    associatedtype Context
    var context: Context { get }
}


public protocol RouterProvider {
    associatedtype Router: RouterType
    var router: Router! { get }
}


open class Router<Route: RouteType>: RouterType {
    public init() { }
    open func route(to route: Route, source: UIViewController) { }
}

open class ContextualRouter<Route: RouteType, Context>: Router<Route>, ContextualRouterType {
    public let context: Context
    
    public init(context: Context) {
        self.context = context
    }
}


public class DynamicRouter<Route: RouteType>: Router<Route> {
    public let route: (Route, UIViewController) -> ()
    
    public init(route: @escaping ((Route, UIViewController) -> ())) {
        self.route = route
    }
    
    public override final func route(to route: Route, source: UIViewController) {
        self.route(route, source)
    }
}

public class DynamicContextualRouter<Route: RouteType, Context>: ContextualRouter<Route, Context> {
    public let route: (Route, Context, UIViewController) -> ()
    
    public init(context: Context, route: @escaping ((Route, Context, UIViewController) -> ())) {
        self.route = route
        super.init(context: context)
    }
    
    public override final func route(to route: Route, source: UIViewController) {
        self.route(route, context, source)
    }
}
