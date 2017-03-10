// javascript 'class' for creating the homepage html
//
// date - Date object for a Monday
//
// 
function EventList(date = null) {
  this.monday = date;
  this.htmlToInsert = "";
  this.ourRequest = null;
  this.weekdays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];
  this.months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];

  this.setMondayDate();
};

// sets the date object for monday and the iso string
// 
// sets this.monday if nil - Date object for current week Monday
// 
// sets mondayISO - String yyyy-mm-dd of a Monday
EventList.prototype.setMondayDate = function() {
  if (this.monday == null) {
    this.getCurrentMonday();
  };
  timezoneOffset = this.monday.getTimezoneOffset() / 60;
  this.mondayISO = new Date(this.monday.getTime());
  this.mondayISO.setHours(this.monday.getHours() - timezoneOffset);
  this.mondayISO = this.mondayISO.toISOString().substr(0,10);
};


// gets current week's Monday
//
// sets this.monday - Date object for current week Monday
EventList.prototype.getCurrentMonday = function() {
  var today = new Date();
  var difference = today.getDay();
  if (difference == 0) {difference = 7};
  this.monday = today;
  this.monday.setDate(this.monday.getDate() - difference + 1);
};


// Makes request to server to get event list
//
// calls onloadFunction
EventList.prototype.addEvents = function() {
  var self = this;
  this.ourRequest = new XMLHttpRequest();
  this.ourRequest.open('GET', "/eventlist?date=" + this.mondayISO, true);
  this.ourRequest.onload = function() {
    onloadFunction.call(self);
  }
  this.ourRequest.send();
};


// Makes html for week of events
//
// this.eventsByWeekday - Hash of weekday -> array of events
function onloadFunction() {
  this.eventsByWeekday = JSON.parse(event.target.responseText);
  this.createHTML();
}

// Creates html for events for the week and adds to index.erb.
//
// if no html to add, create no event message
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
    this.htmlToInsert += "<li>" + "<a class='event-description' href='/event?id=";
    this.htmlToInsert += daysEvents[j]["id"] + "'>";
    this.htmlToInsert += this.getAmPmTime(daysEvents[j]["time"]) + " - ";
    this.htmlToInsert += daysEvents[j]["group_name"] + " - ";
    this.htmlToInsert += daysEvents[j]["title"] + "<br>";
    this.htmlToInsert += "<span class='event-details'><span class='highlight'>";
    this.htmlToInsert += daysEvents[j]["rsvps"] + "</span> people are going.</span></li></a>";
  };
};

// turns 24 hour time into 12 hour AM/PM Time
// 
// time = 24 hour time as string
// 
// returns 12 hour time as string
EventList.prototype.getAmPmTime = function (time){
  var time = (time).split(":")
  var hour = time[0]
  if (time[0] >= 12){
    var ampm = 'pm'
  } else {
    var ampm = 'am'
  }
  if (time[0] > 12){
    return (time[0] - 12) + ":" + time[1] + ampm
  } else {
    return time[0] + ":" + time[1] + ampm
  }
}

// will display the date range for the week as a header
//
// returns nothing, inserts header text in html h2
EventList.prototype.addHeader = function() {
  var dateString = this.createDateString();
  document.getElementsByClassName("events-date")[0].firstElementChild.textContent = dateString;
};

// creates the date range to be displayed in the header
//
// returns a String of the form "February 27 - March 5, 2017"
EventList.prototype.createDateString = function() { 
  var m1d1 = this.months[this.monday.getMonth()] + " " + this.monday.getDate();
  var sunday = this.monday;
  sunday.setDate(sunday.getDate() + 6);
  var m2d2 = this.months[sunday.getMonth()] + " " + sunday.getDate();
  return m1d1 + " - " + m2d2 + ", " + this.monday.getFullYear();
};
