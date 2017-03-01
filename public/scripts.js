window.addEventListener("load", function (){
	// displayHeaderOnHomepage("2017-03-06");
	displayHeaderOnHomepage();
	displayEventsOnHomepage();

	function displayEventsOnHomepage(date = null) {
		var ourRequest = new XMLHttpRequest();
		if (date) {
			ourRequest.open('GET', "/eventlist?date=" + date, true);
		} else {
			ourRequest.open('GET', "/eventlist", true);
		}
		ourRequest.onload = addEvents;
		ourRequest.send();
	}

	function displayHeaderOnHomepage(date=null) {
		if (date) {
			var monday = new Date();
			monday.setTime(Date.parse(date) + 100000000)
		} else {
			monday = getCurrentDate();
		}
		var month = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];
		m1 = month[monday.getMonth()];
		d1 = monday.getDate();
		y = monday.getFullYear();
		var sunday = monday;
		sunday.setDate(sunday.getDate() + 6);
		m2 = month[sunday.getMonth()];
		d2 = sunday.getDate();
		dateString = m1 + " " + d1 + " - " + m2 + " " + d2 + ", " + y;
		document.getElementsByClassName("events-date")[0].firstElementChild.textContent = dateString;
	}

	// Add all events to the homepage.
	// event - get request for events.
	// Adds the html to index for list of the week of events.
	function addEvents(event) {
		var result = event.target.responseText;
		data = JSON.parse(result);
		createHTML(data);		
	};

	// Creates html for events for the week and add to index.erb.
	// data - json data as a hash organized as weekday -> array of events.
	// html added to index.erb.
	function createHTML(data){
		htmlToInsert = "";
		createHTMLForEachWeekday(data);
		document.getElementsByClassName("events")[0].insertAdjacentHTML('beforeend',htmlToInsert);
	}

	// Creates html for events by each weekday.
	// data - json data as a hash organized as weekday -> array of events.
	// html created as a string for all weekdays.
	function createHTMLForEachWeekday(data) {
		weekdays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];
		for (var i=0;i<weekdays.length;i++) {
			if (data[weekdays[i]]){
				htmlToInsert += "<div class='event-item'>";
				htmlToInsert += "<h2>" + weekdays[i] + "</h2><ul>";
				createHTMLForEachEvent(data[weekdays[i]])
				htmlToInsert += "</ul></div>";
			}
		}
	}

	// Creates html for events for a single weekday.
	// daysEvents - an array of events for a single weekday.
	// html created as a string for one weekday.
	function createHTMLForEachEvent(daysEvents) {
		for (var j=0; j<daysEvents.length;j++) {
			htmlToInsert += "<li>";
			htmlToInsert += daysEvents[j]["time"] + " - ";
			htmlToInsert += daysEvents[j]["group"] + " - ";
			htmlToInsert += "<a href='/event?id=" + daysEvents[j]["id"] + "'>"
			htmlToInsert += daysEvents[j]["title"]
			htmlToInsert += "</a></li>";
		}
	}

	var prevWeekButton = document.getElementsByClassName("prevWeek")[0];
	var nextWeekButton = document.getElementsByClassName("nextWeek")[0];

	prevWeekButton.addEventListener("click",showPrevWeek);
	nextWeekButton.addEventListener("click",showNextWeek);

	function showPrevWeek() {
		var currentMonday = getCurrentDate();
		var prevMonday = currentMonday;
		prevMonday.setDate(currentMonday.getDate() - 7);
		mondayDate = prevMonday.toISOString().substr(0,10);
		displayHeaderOnHomepage(mondayDate);
		displayEventsOnHomepage(mondayDate);
	}

	function showNextWeek() {
		var currentMonday = getCurrentDate();
		var nextMonday = currentMonday;
		nextMonday.setDate(currentMonday.getDate() + 7);
		mondayDate = nextMonday.toISOString().substr(0,10);
		displayHeaderOnHomepage(mondayDate);
		displayEventsOnHomepage(mondayDate);
	}

	function getCurrentDate() {
		var dateHeader = document.getElementsByClassName("events-date")[0].firstElementChild;
		var date = dateHeader.textContent.split("-");
		var d = new Date(date[0] + date[1].substr(-4));
		return d;
	}



});





