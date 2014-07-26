angular.module('KNL', ['ngRoute'], ['$routeProvider', function($routeProvider) {
  $routeProvider.when('/simple', {
    templateUrl: 'partials/view/simple.html' ,
    controller: 'Distribution'
  });
  $routeProvider.when('/detailed', {
    templateUrl: 'partials/view/detailed.html' ,
    controller: 'Distribution'
  });
  $routeProvider.when('/details/:item', {
    templateUrl: 'partials/items_details.html' ,
    controller: 'Distribution'
  });
  $routeProvider.otherwise({
    redirectTo: '/simple'
  });
}]);
