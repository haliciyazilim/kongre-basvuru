var kongreApp = angular.module('kongreApp',[]);
kongreApp.controller('registerFormController', ['$scope','$http',function (
  $scope,
  $http
) {
  $scope.attendee = 'attendee';
  $scope.presenter = 'presenter';
  $scope.applicant_type = null;
  $scope.form = {
    relation_to_high_intelligence_other : '',
    applicant:{
      previous_attendances:0,
      relation_to_high_intelligence:null,
      previous_attendances:null
    },
    presentation:{}
  };

  //$scope.form.applicant = {
  //  name:'Yunus Eren',
  //  surname:'Guzel',
  //  email:'yeguzel@halici.com.tr',
  //  tckn:'17515095902',
  //  birthday:'24.04.1989',
  //  phone:'+905324648399',
  //  organization:'Halici',
  //  occupation:'Computer Engineer',
  //  address:'75.Sok 48/3 Bahcelievler Cankaya',
  //  city:'Ankara',
  //  previous_attendances:0,
  //  relation_to_high_intelligence:null,
  //  previous_attendances:null
  //
  //};

  //$scope.form.presentation = {
  //  purpose:"Lorem Ipsum, dizgi ve baskı endüstrisinde kullanılan mıgır metinlerdir. Lorem Ipsum, adı bilinmeyen bir matbaacının bir hurufat numune kitabı oluşturmak üzere bir yazı galerisini alarak karıştırdığı 1500'lerden beri endüstri standardı sahte metinler olarak kullanılmıştır.",
  //  content:"Lorem Ipsum, dizgi ve baskı endüstrisinde kullanılan mıgır metinlerdir. Lorem Ipsum, adı bilinmeyen bir matbaacının bir hurufat numune kitabı oluşturmak üzere bir yazı galerisini alarak karıştırdığı 1500'lerden beri endüstri standardı sahte metinler olarak kullanılmıştır. Beşyüz yıl boyunca varlığını sürdürmekle kalmamış, aynı zamanda pek değişmeden elektronik dizgiye de sıçramıştır. 1960'larda Lorem Ipsum pasajları da içeren Letraset yapraklarının yayınlanması ile ve yakın zamanda Aldus PageMaker gibi Lorem Ipsum sürümleri içeren masaüstü yayıncılık yazılımları ile popüler olmuştur.",
  //  audience:"Lorem Ipsum, dizgi ve baskı endüstrisinde kullanılan mıgır metinlerdir. Lorem Ipsum, adı bilinmeyen bir matbaacının bir hurufat numune kitabı oluşturmak üzere bir yazı galerisini alarak karıştırdığı 1500'lerden beri endüstri standardı sahte metinler olarak kullanılmıştır. "
  //}

  $scope.showApplicationTypeButtons = true;

  $scope.applyAs = function (applicant) {
    $scope.applicant_type = applicant;
    if($scope.applicant_type == $scope.presenter) {
      $scope.showPersonalInfoForm = true;
    } else {
      $scope.showAttendeeWarning = true;
    }
    $scope.showApplicationTypeButtons = false;
    $scope.form.applicant.applicant_type = $scope.applicant_type;
  }

  $scope.setAttendance = function (attendance, add) {
    $scope.form.applicant.previous_attendances = add ?
      $scope.form.applicant.previous_attendances | attendance :
      $scope.form.applicant.previous_attendances & ~attendance;
  }

  $scope.hasEmptyField = function(form) {
    for(var key in form) {
      var value = form[key];
      //console.log(key, value);
      if(form.hasOwnProperty(key) && (!value || value == '')) {
        return true;
      }
    }
    return false;
  }

  $scope.savePersonalInfo = function () {
    var applicantForm = angular.copy($scope.form.applicant);
    if(applicantForm.relation_to_high_intelligence == 'other') {
      applicantForm.relation_to_high_intelligence = $scope.form.relation_to_high_intelligence_other;
    }
    if($scope.hasEmptyField(applicantForm)) {
      alert('Lütfen formu eksiksiz doldurunuz.');
      return;
    }
    $scope.disableSavePersonalInfo = true;
    $http.post('/register',{applicant:applicantForm})
      .success(function (data) {
        $scope.applicant = data;
        if($scope.applicant_type == $scope.presenter) {
          $scope.showPresentationInfoForm = true;
        }
      })
      .error(function () {

      })
      .then(function () {
        $scope.disableSavePersonalInfo = false;
      });
  }

  $scope.submitPresentation = function () {
    if($scope.hasEmptyField($scope.form.presentation)) {
      alert('Lütfen formu eksiksiz doldurunuz.');
      return;
    }
    $scope.disableSubmitPresentation = true;
    $http.post('/register',{
      applicant_id:$scope.applicant.id,
      presentation:$scope.form.presentation
    })
      .success(function (data) {
        $scope.applicant = data;
        $scope.showPresenterSuccessMessage = true;
        $scope.showPersonalInfoForm = false;
        $scope.showPresentationInfoForm = false;
      })
      .error(function () {

      })
  }


}]);