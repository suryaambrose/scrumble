angular.module 'Scrumble.daily-report'
.controller 'DailyReportCtrl', (
  $scope
  $mdToast
  $mdDialog
  $mdMedia
  $document
  reportBuilder
  dailyReport
) ->
  saveFeedback = $mdToast.simple()
    .hideDelay(1000)
    .position('top left')
    .content('Saved!')
    .parent($document[0].querySelector('main'))

  $scope.sections =
    subject: angular.copy dailyReport.sections?.subject
    intro: angular.copy dailyReport.sections?.intro
    progress: angular.copy dailyReport.sections?.progress
    previousGoalsIntro: angular.copy dailyReport.sections?.previousGoalsIntro
    previousGoals: angular.copy dailyReport.sections?.previousGoals
    todaysGoalsIntro: angular.copy dailyReport.sections?.todaysGoalsIntro
    todaysGoals: null
    problems: angular.copy dailyReport.sections?.problems
    conclusion: angular.copy dailyReport.sections?.conclusion

  $scope.saveSection = (section, content) ->
    $mdToast.show saveFeedback
    dailyReport.sections ?= {}
    dailyReport.sections[section] = content
    dailyReport.save().then ->
      $mdToast.hide saveFeedback

  $scope.preview = (ev) ->
    $mdDialog.show
      controller: 'PreviewCtrl'
      templateUrl: 'daily-report/states/preview/view.html'
      parent: angular.element document.body
      targetEvent: ev
      clickOutsideToClose: true
      fullscreen: $mdMedia 'sm'
      resolve:
        message: ->
          reportBuilder.render(
            $scope.sections
            dailyReport
            d3.select('#bdcgraph')[0][0].firstChild
            $scope.project
            $scope.sprint
          )
        dailyReport: -> dailyReport
        todaysGoals: -> $scope.sections.todaysGoals