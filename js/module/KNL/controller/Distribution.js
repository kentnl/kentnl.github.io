angular.module('KNL').controller('Distribution',
    [ '$scope', '$http','$routeParams','$interval', function($scope,$http,$routeParams,$interval) {
      var update = function() {
        $http.get('data/distributions.json').success(function(data){
          $scope.distributions = data;
          if ( $routeParams['item'] ) {
            $scope.item = $routeParams.item
          }
        });
      };
      update();
      $interval(update, 60000);
    }]
);
