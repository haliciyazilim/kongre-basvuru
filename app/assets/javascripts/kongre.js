var kongreApp = angular.module('kongreApp',[]);
kongreApp.controller('registerFormController', ['$scope','$http',function (
  $scope,
  $http
) {
  $scope.attendee = 'attendee';
  $scope.presenter = 'presenter';
  $scope.showWorkshops = false;
  $scope.showCheckout = false;
  $scope.applicant_type = null;
  $scope.totalAmount = 0;
  $scope.workshops24 = workshops24;
  for(var i=0; i< $scope.workshops24.length; i++) {
    $scope.workshops24[i].class = 'info';
  }
  $scope.workshops25 = workshops25;
  for(var i=0; i< $scope.workshops25.length; i++) {
    $scope.workshops25[i].class = 'info';
  }
  $scope.selectedWorkshops = [];
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
  //  applicant_category:'instructor_student',
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
      $scope.showPersonalInfoForm = true;
      //$scope.showAttendeeWarning = true;
    }
    $scope.showApplicationTypeButtons = false;
    $scope.form.applicant.applicant_type = $scope.applicant_type;
  }

  $scope.setAttendance = function (attendance, add) {
    $scope.form.applicant.previous_attendances = add ?
    $scope.form.applicant.previous_attendances | attendance :
    $scope.form.applicant.previous_attendances & ~attendance;
  }

  $scope.toggleSelectedWorkshops = function (id) {
    var workshop = $scope.getSelectedWorkshopWithId(id);
    var index = $scope.selectedWorkshops.indexOf(workshop);
    if (index < 0) {
      $scope.selectedWorkshops.push(workshop);
    }
    else {
      $scope.selectedWorkshops.splice(index, 1);
    }
    $scope.checkWorkshops();
    $scope.refreshTotalAmount();
    $scope.$apply();
  }

  $scope.getSelectedWorkshopWithId = function (id) {
    var workshops = $scope.workshops24.concat($scope.workshops25);
    for(var i=0;i < workshops.length;i++) {
      if(workshops[i].id == id) {
        return workshops[i];
      }
    }
  }
  $scope.checkWorkshops = function () {
    var workshops = $scope.workshops24.concat($scope.workshops25);
    for(var i=0;i<workshops.length; i++) {
      var workshop = workshops[i];
      var start_at = new Date(workshop.start_at);
      var finish_at = new Date(workshop.finish_at);
      var className = 'info';
      for(var j=0;j<$scope.selectedWorkshops.length;j++) {
        var selectedWorkshop = $scope.selectedWorkshops[j];
        if(workshop == selectedWorkshop) {
          className = 'warning';
          break;
        }
        else {
          var selected_start_at = new Date(selectedWorkshop.start_at);
          var selected_finish_at = new Date(selectedWorkshop.finish_at);
          if(selected_start_at < start_at && start_at < selected_finish_at
            || selected_start_at < finish_at && finish_at < selected_finish_at
            || start_at < selected_start_at && selected_start_at < finish_at
            || start_at < selected_finish_at && selected_finish_at < finish_at) {
            className = 'danger';
          }
        }
      }
      workshop.class = className;
    }
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
        else if($scope.applicant_type == $scope.attendee) {
          $scope.showWorkshops = true;
          $scope.showCheckout = true;
        }
      })
      .error(function () { })
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
      .error(function () { })
  }

  $scope.refreshTotalAmount = function () {
    $scope.totalAmount = $scope.form.applicant.applicant_category == 'instructor_student' ? 10000 : 18000;
    for(var i=0; i<$scope.selectedWorkshops.length ; i++) {
      $scope.totalAmount += $scope.selectedWorkshops[i].product.price;
    }
  }
  $scope.$watch('form.applicant.application_category',$scope.refreshTotalAmount);

  $scope.order = function () {
    if(confirm('Ödemeniz gereken toplam tutar olan '+$scope.totalAmount/100+' TL’yi ödemek icin ödeme sayfasına yönlendirileceksiniz, Onaylıyor musunuz?')) {
      var workshops = [];
      for(var i=0; i<$scope.selectedWorkshops.length; i++) {
        workshops.push($scope.selectedWorkshops[i].id);
      }
      $http.post('/order',{
        workshops:workshops,
        applicant_id:$scope.applicant.id
      })
        .success(function (data) {
          //console.log(data)
          window.location = data.redirect_url;
        })
    }
  }

}]);
