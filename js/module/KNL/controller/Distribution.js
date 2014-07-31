angular.module('KNL').controller('Distribution',
[       '$scope', '$http','$routeParams','$interval','$log','$rootScope',
function($scope,   $http,  $routeParams,  $interval,  $log,  $rootScope) {

      $scope.updater = function() {
        $http.get('https://api.github.com/orgs/kentnl/repos', {cache: true}).success(function(data){
          $scope.distributions = data.map(function(item){
            return item['name'];
          });
        });
      };

      if ( $rootScope['updater_interval'] ) {
        $interval.cancel( $rootScope.updater_interval );
      }
      if ( !$routeParams['item'] ) {
        $rootScope['updater_interval'] = $interval( $scope.updater, 60000 );
      }
      $scope.updater();
}]);
