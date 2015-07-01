var kongreApp = angular.module('kongreApp',[]);
kongreApp.controller('registerFormController', function (
  $scope,
  $http
) {
  $scope.attendee = 'attendee';
  $scope.presenter = 'presenter';
  $scope.applicant_type = null;
  $scope.form = {};
  $scope.form = {
    name:'Yunus Eren',
    surname:'Guzel',
    email:'yeguzel@halici.com.tr',
    tckn:'17515095902',
    birthday:'24.04.1989',
    phone:'+905324648399',
    organization:'Halici',
    occupation:'Computer Engineer',
    address:'75.Sok 48/3 Bahcelievler Cankaya',
    city:'Ankara'
  };
  $scope.applicant_id =
  $scope.showApplicationTypeButtons = true;
  $scope.applyAs = function (applicant) {
    $scope.applicant_type = applicant;
    if($scope.applicant_type == $scope.presenter) {
      $scope.showPersonalInfoForm = true;
    } else {
      $scope.showAttendeeWarning = true;
    }
    $scope.showApplicationTypeButtons = false;
    $scope.form.applicant_type = $scope.applicant_type;
  }
  $scope.savePersonalInfo = function () {
    if($scope.applicant_type == $scope.presenter) {
      $scope.showPresentationInfoForm = true;
    }

    $http.post('/register',$scope.form)
      .success(function (data) {
        $scope.applicant = data;
      })
      .error(function () {

      })

  }
})