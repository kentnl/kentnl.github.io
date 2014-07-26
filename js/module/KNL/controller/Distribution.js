angular.module('KNL').controller('Distribution',
    [ '$scope', '$http','$routeParams', function($scope,$http,$routeParams) {
      $http.get('data/distributions.json').success(function(data){
        $scope.distributions = data;
        if ( $routeParams['item'] ) {
          $scope.item = $routeParams.item
        }
      });
    }]
);
