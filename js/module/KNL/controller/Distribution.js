KNL.controller('Distribution',
    [ '$scope', '$http', function($scope,$http) {
      $http.get('data/distributions.json').success(function(data){
        $scope.distributions = data;
      });
    }]
);
