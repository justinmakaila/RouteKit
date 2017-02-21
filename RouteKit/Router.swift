import UIKit


/// A type representing a route
protocol RouteType { }

extension String: RouteType { }


/// A router is routes from a view controller of type `SourceViewController`
/// to a route of type `Route`.
protocol RouterType {
    associatedtype Route: RouteType
    associatedtype SourceViewController: UIViewController
    
    func route(to route: Route, source: SourceViewController)
}


protocol ContextualRouterType: RouterType {
    associatedtype Context
    var context: Context { get }
}


protocol RouterProvider {
    associatedtype Router: RouterType
    var router: Router! { get }
}


class Router<Route: RouteType>: RouterType {
    func route(to route: Route, source: UIViewController) { }
}

class ContextualRouter<Route: RouteType, Context>: Router<Route>, ContextualRouterType {
    let context: Context
    
    init(context: Context) {
        self.context = context
    }
}


class DynamicRouter<Route: RouteType>: Router<Route> {
    let route: (Route, UIViewController) -> ()
    
    init(route: @escaping ((Route, UIViewController) -> ())) {
        self.route = route
    }
    
    override func route(to route: Route, source: UIViewController) {
        self.route(route, source)
    }
}

class DynamicContextualRouter<Route: RouteType, Context>: ContextualRouter<Route, Context> {
    let route: (Route, Context, UIViewController) -> ()
    
    init(context: Context, route: @escaping ((Route, Context, UIViewController) -> ())) {
        self.route = route
        super.init(context: context)
    }
    
    override func route(to route: Route, source: UIViewController) {
        self.route(route, context, source)
    }
}
