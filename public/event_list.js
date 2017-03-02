function EventList(date = null) {
  
  // monday - date object of a Monday
  this.monday = date;

  this.setMondayDate = function() {
    if (this.monday == null) {
      this.getCurrentMonday();
    };
    this.mondayISO = this.monday.toISOString().substr(0,10);
  };

  this.getCurrentMonday = function() {
    today = new Date();
    difference = today.getDay();
    if (difference == 0) {difference = 7};
    this.monday = today;
    this.monday.setDate(this.monday.getDate() - difference + 1);
  };

  this.setMondayDate();


  this.weekdays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];
  this.months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];

  this.htmlToInsert = "";




  // Creates html for events for the week and add to index.erb.
  //
  // events_by_weekday - json data as a hash organized as weekday -> array of events.
  //
  // Returns nothing, results in html added to index.erb.
  this.createHTML = function() {
    this.createHTMLForEachWeekday();
    document.getElementsByClassName("events-list")[0].innerHTML = this.htmlToInsert;
  };

  this.addEvents = function() {
    var that2 = this
    var ourRequest = new XMLHttpRequest();
    ourRequest.open('GET', "/eventlist?date=" + this.mondayISO, true);
    debugger;
    ourRequest.onload = function(){
      debugger;
      this.eventsByWeekday = JSON.parse(event.target.responseText);
      this.createHTML();
    };
    ourRequest.send();
  };

  // Gets a single day of events
  //
  // dayIndex - Integer from 0-6
  //
  // Returns an Array of events for one day
  this.singleDaysEvents = function(dayIndex){
    return this.eventsByWeekday[this.weekdays[dayIndex]];
  };

  // Creates html for events by each weekday.
  //
  // data - json data as a hash organized as weekday -> array of events.
  //
  // Returns nothing, results in html created as a string for all weekdays.
  this.createHTMLForEachWeekday = function () {
    for (var i=0; i < this.weekdays.length; i++) {
      if (this.eventsByWeekday[this.weekdays[i]]){
        this.htmlToInsert += "<div class='event-item'>";
        this.htmlToInsert += "<h2>" + this.weekdays[i] + "</h2><ul>";
        this.createHTMLForEachEvent(this.singleDaysEvents(i))
        this.htmlToInsert += "</ul></div>";
      };
    };
  };

  // Creates html for events for a single weekday.
  //
  // daysEvents - an array of events for a single weekday.
  // 
  // html created as a string for one weekday.
  this.createHTMLForEachEvent = function (daysEvents) {
    for (var j=0; j<daysEvents.length;j++) {
      this.htmlToInsert += "<li>";
      this.htmlToInsert += daysEvents[j]["time"] + " - ";
      this.htmlToInsert += daysEvents[j]["group"] + " - ";
      this.htmlToInsert += "<a href='/event?id=" + daysEvents[j]["id"] + "'>"
      this.htmlToInsert += daysEvents[j]["title"]
      this.htmlToInsert += "</a></li>";
    };
  };



  // will display the date range for the week as a header
  // date is the date of the monday of the week as yyyy-mm-dd
  // returns nothing, inserts header text in html h2
  this.addHeader = function() {
    dateString = this.createDateString();
    document.getElementsByClassName("events-date")[0].firstElementChild.textContent = dateString;
  };


  // creates the string to be displayed in the header
  // monday is a date object of a monday
  // returns a string of the form "February 27 - March 5, 2017"
  this.createDateString = function() { 
    m1d1 = this.months[this.monday.getMonth()] + " " + this.monday.getDate();
    var sunday = this.monday;
    sunday.setDate(sunday.getDate() + 6);
    m2d2 = this.months[sunday.getMonth()] + " " + sunday.getDate();
    return m1d1 + " - " + m2d2 + ", " + this.monday.getFullYear();
  };


};