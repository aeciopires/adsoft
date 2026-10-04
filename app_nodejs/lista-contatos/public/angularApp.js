// Create an Angular module called contactList
var contactList = angular.module('contactList', []);

contactList.controller('mainController', ['$scope', '$http', function ($scope, $http) {

    function logError(response) {
        console.log('Error: ', response.data);
    }

    // When the page is loaded, get all the contacts and send them to the view ($scope)
    var refresh = function () {
        $http.get('/api/contacts')
            .then(function (response) {
                $scope.contacts = response.data;
                $scope.formContact = {};
                console.log('contacts: ', response.data);
            }, logError);
    };
    refresh();

    // When the Create button is clicked, send the data to the Node API
    $scope.createContact = function () {
        $http.post('/api/contacts', $scope.formContact)
            .then(function (response) {
                // Clear the form to create other contacts
                $scope.formContact = {};
                $scope.contacts = response.data;
                console.log(response.data);
            }, logError);
    };

    // When the Remove button is clicked, delete the contact
    $scope.deleteContact = function (id) {
        $http.delete('/api/contacts/' + id)
            .then(function (response) {
                $scope.contacts = response.data;
                console.log(response.data);
            }, logError);
    };

    // When the Edit button is clicked, load the contact in the form
    $scope.editContact = function (id) {
        $http.get('/api/contacts/' + id)
            .then(function (response) {
                $scope.formContact = response.data;
                console.log(response.data);
            }, logError);
    };

    // Send the contact being edited to the API and update the list
    $scope.updateContact = function () {
        $http.put('/api/contacts/' + $scope.formContact._id, $scope.formContact)
            .then(function () {
                refresh();
            }, logError);
    };

}]);
