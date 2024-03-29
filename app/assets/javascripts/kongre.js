var kongreApp = angular.module("kongreApp", [
  "duScroll",
  "ui-notification",
  "ui.bootstrap",
  "cwill747.phonenumber",
  "templates",
]);
kongreApp.controller("registerFormController", [
  "$scope",
  "$http",
  "$document",
  "$timeout",
  "$log",
  "$modal",
  "Notification",
  function ($scope, $http, $document, $timeout, $log, $modal, Notification) {
    $scope.actionState = {
      invalid: -1,
      onIdle: 0,
      onAction: 1,
    };

    $scope.ticketsOver = false;

    $scope.currentYear = new Date().getFullYear();
    $scope.personalInfoState = $scope.actionState.onIdle;
    $scope.orderState = $scope.actionState.onIdle;

    $scope.attendee = "attendee";
    $scope.presenter = "presenter";
    $scope.showWorkshops = false;
    $scope.showCheckout = false;
    $scope.applicant_type = null;
    $scope.totalAmount = 29500;
    $scope.workshops25 = workshops25;
    for (var i = 0; i < $scope.workshops25.length; i++) {
      $scope.workshops25[i].class = "info";
    }
    $scope.workshops26 = workshops26;
    for (var i = 0; i < $scope.workshops26.length; i++) {
      $scope.workshops26[i].class = "info";
    }
    $scope.selectedWorkshops = [];
    $scope.form = {
      applicant: {
        gender: null,
      },
      presentation: {},
      couponCode: "",
    };

    $scope.discount = 0;

    // $scope.form.applicant = {
    //  name:'Yunus Eren',
    //  surname:'Guzel',
    //  email:'yeguzel@halici.com.tr',
    //  tckn:'17515095902',
    //  birthday:'24.04.1989',
    //  // phone:'+905324648399',
    //  gender : "erkek",
    //  haberdar_olunan_yer : "sosyal medya",
    //  // organization:'Halici',
    //  occupation:'Computer Engineer',
    //  address:'75.Sok 48/3 Bahcelievler Cankaya',
    //  city:'Ankara',
    //  //applicant_category:'instructor_student',
    // };

    $scope.showApplicationTypeButtons = true;

    var scrollTo = function (id) {
      var offset = 10;
      var duration = 750;
      var someElement = angular.element(document.getElementById(id));
      $document.scrollToElement(someElement, offset, duration);
    };

    $scope.applyAs = function (applicant) {
      $scope.applicant_type = applicant;
      if ($scope.applicant_type == $scope.presenter) {
        $scope.showPersonalInfoForm = true;
      } else {
        $scope.showPersonalInfoForm = true;
        //$scope.showAttendeeWarning = true;
      }
      $scope.showApplicationTypeButtons = false;
      $scope.form.applicant.applicant_type = $scope.applicant_type;
    };

    $scope.attendances = {
      attendance2019: false,
      attendance2018: false,
      attendance2017: false,
      attendance2016: false,
      attendance2015: false,
      attendance2014: false,
      attendance2013: false,
      attendanceFirst: false,
    };

    $scope.setAttendance = function (attendance, add) {
      $scope.attendances[attendance] = add;

      if (attendance == "attendanceFirst") {
        $scope.attendances.attendance2013 = false;
        $scope.attendances.attendance2014 = false;
        $scope.attendances.attendance2015 = false;
        $scope.attendances.attendance2016 = false;
        $scope.attendances.attendance2017 = false;
        $scope.attendances.attendance2018 = false;
        $scope.attendances.attendance2019 = false;
      } else {
        $scope.attendances.attendanceFirst = false;
      }
      $scope.form.applicant.previous_attendances = calculatePreviousAttendance(
        $scope.attendances
      );
    };

    function calculatePreviousAttendance(object) {
      var attendanceBinary = "";

      for (var property in object) {
        if (object.hasOwnProperty(property)) {
          if (object[property]) {
            attendanceBinary += "1";
          } else {
            attendanceBinary += "0";
          }
        }
      }

      return parseInt(attendanceBinary, 2);
    }

    $scope.toggleSelectedWorkshops = function (id) {
      var workshop = $scope.getSelectedWorkshopWithId(id);
      var index = $scope.selectedWorkshops.indexOf(workshop);
      if (index < 0) {
        $scope.selectedWorkshops.push(workshop);
      } else {
        $scope.selectedWorkshops.splice(index, 1);
      }
      $scope.checkWorkshops();
      $scope.refreshTotalAmount();
      $scope.$apply();
    };

    $scope.getSelectedWorkshopWithId = function (id) {
      var workshops = $scope.workshops25.concat($scope.workshops26);
      for (var i = 0; i < workshops.length; i++) {
        if (workshops[i].id == id) {
          return workshops[i];
        }
      }
    };
    $scope.checkWorkshops = function () {
      var workshops = $scope.workshops25.concat($scope.workshops26);
      for (var i = 0; i < workshops.length; i++) {
        var workshop = workshops[i];
        var start_at = new Date(workshop.start_at);
        var finish_at = new Date(workshop.finish_at);
        var className = "info";
        for (var j = 0; j < $scope.selectedWorkshops.length; j++) {
          var selectedWorkshop = $scope.selectedWorkshops[j];
          if (workshop == selectedWorkshop) {
            className = "warning";
            break;
          } else {
            var selected_start_at = new Date(selectedWorkshop.start_at);
            var selected_finish_at = new Date(selectedWorkshop.finish_at);
            if (
              (start_at >= selected_start_at &&
                start_at <= selected_finish_at) ||
              (finish_at >= selected_start_at &&
                finish_at <= selected_finish_at)
            ) {
              className = "danger";
            }
          }
        }
        if (workshop.product.stock < 1) {
          className = "danger";
        }
        console.log(">>>>> ", workshop, className);
        workshop.className = className;
      }
    };
    //$scope.checkWorkshops();

    $scope.hasEmptyField = function (form) {
      for (var key in form) {
        var value = form[key];
        //console.log(key, value);
        if (form.hasOwnProperty(key) && (!value || value == "")) {
          return true;
        }
      }
      return false;
    };

    $scope.savePersonalInfo = function (form) {
      $scope.form.applicant.is_attending = "true";
      var applicantData = angular.copy($scope.form.applicant);
      var applicantForm = applicantData;
      // if (applicantForm.relation_to_high_intelligence == "other") {
      //   if (!$scope.form.relation_to_high_intelligence_other) {
      //     $scope.showErrorNotification(
      //       "Diğer seçeneğini seçtiniz, Lütfen açıklamasını giriniz."
      //     );
      //     return;
      //   }
      //   applicantForm.relation_to_high_intelligence =
      //     $scope.form.relation_to_high_intelligence_other;
      // }

      if ($scope.form.applicant.phone.length != 10) {
        $scope.showErrorNotification(
          "Lütfen telefon numaranızı başında 0 olmadan 10 hane olarak giriniz."
        );
        return;
      }
      if ($scope.form.applicant.previous_attendances == null) {
        $scope.showErrorNotification("Lütfen formu eksiksiz doldurunuz.");
        return;
      }
      if ($scope.hasEmptyField(applicantForm)) {
        $scope.showErrorNotification("Lütfen formu eksiksiz doldurunuz.");
        return;
      }

      $scope.personalInfoState = $scope.actionState.onAction;
      $http.post("/register", { applicant: applicantForm }).then(
        function (data) {
          if (data.error_message) {
            alert(data.error_message);
          } else {
            $scope.applicant = data.data;
            $scope.applicant.is_attending = "true";
            console.log("applicant: ", $scope.applicant);
            $log.info("Register: ", $scope.applicant);
            $scope.refreshTotalAmount();

            if ($scope.applicant_type == $scope.presenter) {
              $scope.showPresentationInfoForm = true;
            } else if ($scope.applicant_type == $scope.attendee) {
              $scope.showWorkshops = true;
              $scope.showCheckout = true;
            }
          }
        },
        function (error) {
          console.log("error: ", error);
          $scope.showErrorNotification(
            error.data.error.error_description,
            3000
          );
        }
      );

      $timeout(function () {
        if ($scope.showPresentationInfoForm) {
          scrollTo("presentationInfoForm");
        } else scrollTo("workshopsExplanation");
        // else scrollTo("checkoutPanel");
      }, 500);

      $scope.personalInfoState = $scope.actionState.onIdle;
      // .success(function (data) {
      //     $scope.applicant = data;
      //     $log.info('Register: ', $scope.applicant);
      //     $scope.refreshTotalAmount();
      //
      //     if ($scope.applicant_type == $scope.presenter) {
      //         $scope.showPresentationInfoForm = true;
      //     }
      //     else if ($scope.applicant_type == $scope.attendee) {
      //         $scope.showWorkshops = true;
      //         $scope.showCheckout = true;
      //     }
      // })
      // .error(function () {
      // })
      // .then(function () {
      //
      //     $timeout(function () {
      //         if ($scope.showPresentationInfoForm) {
      //             scrollTo('presentationInfoForm');
      //         }
      //         else
      //         //scrollTo('workshopsPanel');
      //             scrollTo('checkoutPanel');
      //     }, 500);
      //
      //     $scope.personalInfoState = $scope.actionState.onIdle;
      // });
    };

    $scope.submitPresentation = function () {
      if ($scope.hasEmptyField($scope.form.presentation)) {
        $scope.showErrorNotification("Lütfen formu eksiksiz doldurunuz.");
        return;
      }
      $scope.disableSubmitPresentation = true;
      $http
        .post("/register", {
          applicant_id: $scope.applicant.id,
          presentation: $scope.form.presentation,
        })
        .then(
          function (data) {
            $scope.applicant = data;
            $scope.showPresenterSuccessMessage = true;
            $scope.showPersonalInfoForm = false;
            $scope.showPresentationInfoForm = false;
          },
          function (error) {}
        );
    };

    var resetForm = function () {
      //$scope.selectedWorkshops = [];
      //
      for (var i = 0; i < $scope.selectedWorkshops.length; i++) {
        $scope.toggleSelectedWorkshops($scope.selectedWorkshops[i].id);
      }
      $scope.selectedWorkshops = [];

      for (var i = 0; i < $scope.workshops25.length; i++)
        $scope.workshops25[i].is_selected = false;

      for (var i = 0; i < $scope.workshops26.length; i++)
        $scope.workshops26[i].is_selected = false;
      //$scope.selectedWorkshops[i].is_selected=false;

      if ($scope.applicant_type == $scope.presenter) {
        $scope.showPresentationInfoForm = false;
      } else if ($scope.applicant_type == $scope.attendee) {
        $scope.showWorkshops = false;
        $scope.showCheckout = false;
      }
      $scope.checkWorkshops();
    };

    $scope.downloadParticipants = function () {
      $log.info("****** Download -***** ");
      $http.get("/admin/receiptsxlsx", {});
    };

    $scope.refreshTotalAmount = function () {
      $scope.totalAmount =
        $scope.form.applicant.is_attending == "true" ? 29500 : 0;

      console.log("total amount: ", $scope.totalAmount);

      for (var i = 0; i < $scope.selectedWorkshops.length; i++) {
        var workshop = $scope.selectedWorkshops[i];
        $log.info("workShop: ", workshop);
        $scope.totalAmount += workshop.product.price;
      }
      $scope.totalAmount -= $scope.discount;

      $scope.orderState =
        $scope.totalAmount <= 0
          ? $scope.actionState.invalid
          : $scope.actionState.onIdle;
    };

    $scope.$watch("form.applicant.applicant_category", function () {
      // resetForm();
      $scope.refreshTotalAmount();
    });

    $scope.$watch("form.applicant.is_attending", function () {
      // resetForm();
      $scope.refreshTotalAmount();
    });

    $scope.couponCheck = function (code) {
      $http
        .get("/coupon_check", {
          params: {
            code: $scope.form.couponCode,
            email: $scope.form.applicant.email,
          },
        })
        .then(
          function (response) {
            $scope.discount = response.data.amount * 100;
            $scope.refreshTotalAmount();
          },
          function (error) {
            $log.info("error on coupon check: ", error);
            $scope.showErrorNotification(
              error.data.error.error_description,
              3000
            );
          }
        );
    };

    $scope.order = function (isConfirmed) {
      if (isConfirmed) {
        $scope.orderState = $scope.actionState.onAction;
        var workshops = [];
        for (var i = 0; i < $scope.selectedWorkshops.length; i++) {
          var workshop = $scope.selectedWorkshops[i];

          if (
            $scope.form.applicant.applicant_category == "child" &&
            !workshop.for_children
          )
            continue;

          workshops.push(workshop.id);
        }
        $http
          .post("/order", {
            workshops: workshops,
            applicant_id: $scope.applicant.id,
            coupon_code: $scope.form.couponCode,
            is_attending: $scope.form.applicant.is_attending,
          })
          .then(
            function (data) {
              console.log(data);
              window.location = data.data.redirect_url;
            },
            function (error) {
              $scope.orderState = $scope.actionState.onIdle;
              $scope.showErrorNotification();
            }
          );
      } else {
        var text =
          "Ödemeniz gereken toplam tutar olan " +
          $scope.totalAmount / 100 +
          " TL’yi ödemek için ödeme sayfasına yönlendirileceksiniz, ücret iadesi mümkün olmayacaktır; onaylıyor musunuz?";

        showOrderAlert(text);
      }
    };

    $scope.freeOrder = function (isConfirmed) {
      if (isConfirmed) {
        $scope.orderState = $scope.actionState.onAction;
        var workshops = [];
        for (var i = 0; i < $scope.selectedWorkshops.length; i++) {
          var workshop = $scope.selectedWorkshops[i];

          if (
            $scope.form.applicant.applicant_category == "child" &&
            !workshop.for_children
          )
            continue;

          workshops.push(workshop.id);
        }
        $http
          .post("/order", {
            workshops: workshops,
            applicant_id: $scope.applicant.id,
            coupon_code: $scope.form.couponCode,
            is_attending: $scope.form.applicant.is_attending,
          })
          .then(
            function (response) {
              $scope.showSuccessNotification(response.data.text, 20000);
              setTimeout(function () {
                window.location = "/";
              }, 20000);
            },
            function (error) {
              $scope.orderState = $scope.actionState.onIdle;
              $scope.showErrorNotification();
            }
          );
      } else {
        var text =
          "Ücretsiz katılım kuponu sadece bir kere kullanılabilir, girdiğiniz bilgiler ile ücretsiz katılım kuponunuzu kullanmak üzeresiniz; onaylıyor musunuz?";

        showFreeOrderAlert(text);
      }
    };

    $scope.showSuccessNotification = function (text, duration) {
      if (text) {
        //text='İşleminiz başarıyla gerçekleştrildi.'

        var currentDuration = 1000;

        if (duration) currentDuration = duration;

        Notification.success({ message: text, delay: currentDuration });
      }
    };

    $scope.showErrorNotification = function (text, duration) {
      if (!text) {
        text = "Bilinmeyen bir hata oluştu; lütfen tekrar deneyiniz.";
      }

      var currentDuration = 3000;

      if (duration) currentDuration = duration;

      Notification.error({ message: text, delay: currentDuration });

      //$log.error(text);
    };

    var showFreeOrderAlert = function (text) {
      var modalInstance = $modal.open({
        animation: true,
        templateUrl: "order_alert_modal.html",
        controller: "OrderAlertModalController",
        size: "md",
        resolve: {
          text: function () {
            return text;
          },
        },
      });

      modalInstance.result.then(
        function () {
          $scope.freeOrder(true);
        },
        function () {}
      );
    };

    var showOrderAlert = function (text) {
      var modalInstance = $modal.open({
        animation: true,
        templateUrl: "order_alert_modal.html",
        controller: "OrderAlertModalController",
        size: "md",
        resolve: {
          text: function () {
            return text;
          },
        },
      });

      modalInstance.result.then(
        function () {
          $scope.order(true);
        },
        function () {}
      );
    };

    $scope.cities = [
      { value: "Adana", name: "Adana" },
      { value: "Adıyaman", name: "Adıyaman" },
      { value: "Afyonkarahisar", name: "Afyonkarahisar" },
      { value: "Ağrı", name: "Ağrı" },
      { value: "Amasya", name: "Amasya" },
      { value: "Ankara", name: "Ankara" },
      { value: "Antalya", name: "Antalya" },
      { value: "Artvin", name: "Artvin" },
      { value: "Aydın", name: "Aydın" },
      { value: "Balıkesir", name: "Balıkesir" },
      { value: "Bilecik", name: "Bilecik" },
      { value: "Bingöl", name: "Bingöl" },
      { value: "Bitlis", name: "Bitlis" },
      { value: "Bolu", name: "Bolu" },
      { value: "Burdur", name: "Burdur" },
      { value: "Bursa", name: "Bursa" },
      { value: "Çanakkale", name: "Çanakkale" },
      { value: "Çankırı", name: "Çankırı" },
      { value: "Çorum", name: "Çorum" },
      { value: "Denizli", name: "Denizli" },
      { value: "Diyarbakır", name: "Diyarbakır" },
      { value: "Edirne", name: "Edirne" },
      { value: "Elazığ", name: "Elazığ" },
      { value: "Erzincan", name: "Erzincan" },
      { value: "Erzurum", name: "Erzurum" },
      { value: "Eskişehir", name: "Eskişehir" },
      { value: "Gaziantep", name: "Gaziantep" },
      { value: "Giresun", name: "Giresun" },
      { value: "Gümüşhane", name: "Gümüşhane" },
      { value: "Hakkâri", name: "Hakkâri" },
      { value: "Hatay", name: "Hatay" },
      { value: "Isparta", name: "Isparta" },
      { value: "Mersin", name: "Mersin" },
      { value: "İstanbul", name: "İstanbul" },
      { value: "İzmir", name: "İzmir" },
      { value: "Kars", name: "Kars" },
      { value: "Kastamonu", name: "Kastamonu" },
      { value: "Kayseri", name: "Kayseri" },
      { value: "Kırklareli", name: "Kırklareli" },
      { value: "Kırşehir", name: "Kırşehir" },
      { value: "Kocaeli", name: "Kocaeli" },
      { value: "Konya", name: "Konya" },
      { value: "Kütahya", name: "Kütahya" },
      { value: "Malatya", name: "Malatya" },
      { value: "Manisa", name: "Manisa" },
      { value: "Kahramanmaraş", name: "Kahramanmaraş" },
      { value: "Mardin", name: "Mardin" },
      { value: "Muğla", name: "Muğla" },
      { value: "Muş", name: "Muş" },
      { value: "Nevşehir", name: "Nevşehir" },
      { value: "Niğde", name: "Niğde" },
      { value: "Ordu", name: "Ordu" },
      { value: "Rize", name: "Rize" },
      { value: "Sakarya", name: "Sakarya" },
      { value: "Samsun", name: "Samsun" },
      { value: "Siirt", name: "Siirt" },
      { value: "Sinop", name: "Sinop" },
      { value: "Sivas", name: "Sivas" },
      { value: "Tekirdağ", name: "Tekirdağ" },
      { value: "Tokat", name: "Tokat" },
      { value: "Trabzon", name: "Trabzon" },
      { value: "Tunceli", name: "Tunceli" },
      { value: "Şanlıurfa", name: "Şanlıurfa" },
      { value: "Uşak", name: "Uşak" },
      { value: "Van", name: "Van" },
      { value: "Yozgat", name: "Yozgat" },
      { value: "Zonguldak", name: "Zonguldak" },
      { value: "Aksaray", name: "Aksaray" },
      { value: "Bayburt", name: "Bayburt" },
      { value: "Karaman", name: "Karaman" },
      { value: "Kırıkkale", name: "Kırıkkale" },
      { value: "Batman", name: "Batman" },
      { value: "Şırnak", name: "Şırnak" },
      { value: "Bartın", name: "Bartın" },
      { value: "Ardahan", name: "Ardahan" },
      { value: "Iğdır", name: "Iğdır" },
      { value: "Yalova", name: "Yalova" },
      { value: "Karabük", name: "Karabük" },
      { value: "Kilis", name: "Kilis" },
      { value: "Osmaniye", name: "Osmaniye" },
      { value: "Düzce", name: "Düzce" },
      { value: "Diğer", name: "Diğer" },
    ];
    $scope.applyAs($scope.attendee);
  },
]);

kongreApp.controller(
  "OrderAlertModalController",
  function ($scope, $modalInstance, text) {
    $scope.text = text;

    $scope.confirm = function () {
      $modalInstance.close();
    };

    $scope.cancel = function () {
      $modalInstance.dismiss("cancel");
    };
  }
);
