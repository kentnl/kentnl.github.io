angular.module('KNL').controller('Distribution',
[       '$scope', '$http','$routeParams','$interval','$log','$rootScope',
function($scope,   $http,  $routeParams,  $interval,  $log,  $rootScope) {

      // Unfortunately, the native github API sucks for public access web pages
      // and this endpoint gives more data than we need, ordered badly,'
      // and requiring us to do stupid paginating shit, and incur stupid
      // rate-limit penalties for the privilege.
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

      // This is the function that fetches JSON data, processes it
      // and injects it into the page.
      $scope.updater = function() {
        $http.get( providers[provider].source, {cache: true}).success(function(data){
          data.sort( providers[provider].sorter );
          $scope.distributions = data.map( providers[provider].mapper);
        });
      };

      // This controller may be invoked multiple times,
      // but when it does, a previous instance of this controller will cease to be
      // useful. So its important we cancel its updater so it doesn't needlessly pound
      // web servers in the background without benefit.
      //
      // Or for that matter, create a forever growing collection of updaters
      // that hammer the server, growing in number each time a user clicks a link >_>
      if ( $rootScope['updater_interval'] ) {
        $interval.cancel( $rootScope.updater_interval );
      }

      // If we're in "single item" view, the name of the chosen item is in itself
      // sufficient to generate the page without needing to query the data from github.
      if ( $routeParams['item'] ) {
        $scope.item = $routeParams.item
      }

      // Otherwise, we're in full page mode, and we'll need data updated
      // every 60 seconds, and a data-update hit will have to fire after loading the page.
      if ( !$routeParams['item'] ) {
        $rootScope['updater_interval'] = $interval( $scope.updater, 60000 );
        $scope.updater();
      }
}]);
