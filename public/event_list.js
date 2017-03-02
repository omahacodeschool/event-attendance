function EventList(eventsByWeekday) {
  this.eventsByWeekday = eventsByWeekday;
  // @eventsByWeekday = eventsByWeekday

  this.weekdays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];

  this.htmlToInsert = "";

  // Creates html for events for the week and add to index.erb.
  // events_by_weekday - json data as a hash organized as weekday -> array of events.
  // html added to index.erb.
  this.createHTML = function(){
    this.createHTMLForEachWeekday();

    document.getElementsByClassName("events")[0].insertAdjacentHTML('beforeend',this.htmlToInsert);
  }

  this.singleDaysEvents = function(dayIndex){
    return this.eventsByWeekday[this.weekdays[dayIndex]];
  }

  // Creates html for events by each weekday.
  // data - json data as a hash organized as weekday -> array of events.
  // html created as a string for all weekdays.
  this.createHTMLForEachWeekday = function () {
    for (var i=0; i < this.weekdays.length; i++) {
      if (this.eventsByWeekday[this.weekdays[i]]){
        this.htmlToInsert += "<div class='event-item'>";
        this.htmlToInsert += "<h2>" + this.weekdays[i] + "</h2><ul>";
        this.createHTMLForEachEvent(this.singleDaysEvents(i))
        this.htmlToInsert += "</ul></div>";
      }
    }
  }

  // Creates html for events for a single weekday.
  // daysEvents - an array of events for a single weekday.
  // html created as a string for one weekday.
  this.createHTMLForEachEvent = function (daysEvents) {
    for (var j=0; j<daysEvents.length;j++) {
      this.htmlToInsert += "<li>";
      this.htmlToInsert += daysEvents[j]["time"] + " - ";
      this.htmlToInsert += daysEvents[j]["group"] + " - ";
      this.htmlToInsert += "<a href='/event?id=" + daysEvents[j]["id"] + "'>"
      this.htmlToInsert += daysEvents[j]["title"]
      this.htmlToInsert += "</a></li>";
    }
  }
}