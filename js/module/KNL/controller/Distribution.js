angular.module('KNL').controller('Distribution',
[       '$scope', '$http','$routeParams','$interval','$log','$rootScope',
function($scope,   $http,  $routeParams,  $interval,  $log,  $rootScope) {

      var providers = {
        'api': {
          source: 'https://api.github.com/orgs/kentnl/repos',
          sorter: function(a,b)  { return a['pushed_at'].localeCompare(b['pushed_at']); },
          mapper: function(item) { return item['name']; }
        },
        'data': {
          source: 'data/distributions.json',
          sorter: function(a,b) { return a.localeCompare(b); },
          mapper: function(item) { return item; }
        }
      };

      var provider = 'data';


      $scope.updater = function() {
        $http.get( providers[provider].source, {cache: true}).success(function(data){
          data.sort( providers[provider].sorter );
          $scope.distributions = data.map( providers[provider].mapper);
        });
      };

      if ( $rootScope['updater_interval'] ) {
        $interval.cancel( $rootScope.updater_interval );
      }
      if ( $routeParams['item'] ) {
        $scope.item = $routeParams.item
      }

      if ( !$routeParams['item'] ) {
        $rootScope['updater_interval'] = $interval( $scope.updater, 60000 );
        $scope.updater();
      }
}]);
