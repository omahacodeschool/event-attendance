function EventList(date = null) {
  
  // monday - date object of a Monday
  this.monday = date;

  this.setMondayDate();

  this.weekdays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];
  this.months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];

  // Create empty String variable of html to insert in dom of index.erb
  this.htmlToInsert = "";
  this.ourRequest = null;
};

// sets the date object for monday and the iso string
// 
// sets monday if it is not provided to the monday of the current week
// sets a string of yyyy-mm-dd to mondayISO from monday
EventList.prototype.setMondayDate = function() {
  if (this.monday == null) {
    this.getCurrentMonday();
  };
  this.mondayISO = this.monday.toISOString().substr(0,10);
};


// gets the date for monday of the current week
//
// sets monday to the date object of the monday of the current week
EventList.prototype.getCurrentMonday = function() {
  var today = new Date();
  var difference = today.getDay();
  if (difference == 0) {difference = 7};
  this.monday = today;
  this.monday.setDate(this.monday.getDate() - difference + 1);
};


// Makes request to server to get event list
// Calls onloadFunction
EventList.prototype.addEvents = function() {
  var self = this;
  this.ourRequest = new XMLHttpRequest();
  this.ourRequest.open('GET', "/eventlist?date=" + this.mondayISO, true);
  this.ourRequest.onload = function() {
    onloadFunction.call(self);
  }
  this.ourRequest.send();
};



function onloadFunction() {
  this.eventsByWeekday = JSON.parse(event.target.responseText);
  this.createHTML();
}

// Creates html for events for the week and adds to index.erb.
//
// eventsByWeekday - json data as a hash organized as weekday -> array of events.
//
// Returns nothing, results in html added to index.erb.
EventList.prototype.createHTML = function() {
  this.createHTMLForEachWeekday();
  if (this.htmlToInsert == "") {this.htmlToInsert = "<p>No events</p>"}
  document.getElementsByClassName("events-list")[0].innerHTML = this.htmlToInsert;
};

// Gets a single day of events
//
// dayIndex - Integer from 0-6
//
// Returns an Array of events for one day
EventList.prototype.singleDaysEvents = function(dayIndex){
  return this.eventsByWeekday[this.weekdays[dayIndex]];
};

// Creates html for events by each weekday.
//
// data - json data as a hash organized as weekday -> array of events.
//
// Returns nothing, results in html created as a string for all weekdays.
EventList.prototype.createHTMLForEachWeekday = function () {
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
EventList.prototype.createHTMLForEachEvent = function (daysEvents) {
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
EventList.prototype.addHeader = function() {
  var dateString = this.createDateString();
  document.getElementsByClassName("events-date")[0].firstElementChild.textContent = dateString;
};

// creates the string to be displayed in the header
// monday is a date object of a monday
// returns a string of the form "February 27 - March 5, 2017"
EventList.prototype.createDateString = function() { 
  var m1d1 = this.months[this.monday.getMonth()] + " " + this.monday.getDate();
  var sunday = this.monday;
  sunday.setDate(sunday.getDate() + 6);
  var m2d2 = this.months[sunday.getMonth()] + " " + sunday.getDate();
  return m1d1 + " - " + m2d2 + ", " + this.monday.getFullYear();
};
