angular.module('KNL').controller('Distribution',
[       '$scope', '$http','$routeParams','$interval','$log','$rootScope',
function($scope,   $http,  $routeParams,  $interval,  $log,  $rootScope) {

      $scope.updater = function() {
        $http.get('data/distributions.json').success(function(data){
          $scope.distributions = data;
          if ( $routeParams['item'] ) {
            $scope.item = $routeParams.item
          }
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
