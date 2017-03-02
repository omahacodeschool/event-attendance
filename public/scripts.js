window.addEventListener("load", function (){

	// Checks to see if the body tag has a particular class.
	//
	// className - String.
	//
	// returns a boolean (true / false).
	function bodyHasClass(className){
		if (window.body == undefined){
			window.body = document.getElementsByTagName("body")[0];
		}
		return window.body.classList.contains(className);
	};

	if (bodyHasClass("index_page")){
		displayHeaderOnHomepage();
		displayEventsOnHomepage();

		// get events for a specific week from server 
		// and display them by creating and inserting html
		// on to homepage as a list
		// date is the date of the monday of the week as yyyy-mm-dd
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

		// will display the date range for the week as a header
		// date is the date of the monday of the week as yyyy-mm-dd
		// returns nothing, inserts header text in html h2
		function displayHeaderOnHomepage(date=null) {
			if (date) {
				var monday = new Date();
				monday.setTime(Date.parse(date.replace(/-/g, '\/')));
			} else {
				monday = getCurrentDate();
			}
			dateString = createDateString(monday);
			document.getElementsByClassName("events-date")[0].firstElementChild.textContent = dateString;
		}

		// creates the string to be displayed in the header
		// monday is a date object of a monday
		// returns a string of the form "February 27 - March 5, 2017"
		function createDateString(monday) {
			var month = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];
			m1d1 = month[monday.getMonth()] + " " + monday.getDate();
			var sunday = monday;
			sunday.setDate(sunday.getDate() + 6);
			m2d2 = month[sunday.getMonth()] + " " + sunday.getDate();
			return m1d1 + " - " + m2d2 + ", " + monday.getFullYear();
		}

		var ourRequest = new XMLHttpRequest();
		ourRequest.open('GET', "/eventlist", true);
		ourRequest.onload = addEvents;
		ourRequest.send();

		// Add all events to the homepage.
		// event - get request for events.
		// Adds the html to index for list of the week of events.
		function addEvents(event) {
			var data = JSON.parse(event.target.responseText);

			var list = new EventList(data)
			list.createHTML();
		};

		// create event listeners for previous and next buttons
		// buttons on homepage
		var prevWeekButton = document.getElementsByClassName("prevWeek")[0];
		var nextWeekButton = document.getElementsByClassName("nextWeek")[0];
		prevWeekButton.addEventListener("click",showPrevWeek);
		nextWeekButton.addEventListener("click",showNextWeek);

		// run when previous week button is clicked
		// 
		// does not return anything, but creates and inserts html
		// for the header and event list on the homepage 
		// for the week previous to what was being displayed
		function showPrevWeek() {
			var currentMonday = getCurrentDate();
			var prevMonday = currentMonday;
			prevMonday.setDate(currentMonday.getDate() - 7);
			mondayDate = prevMonday.toISOString().substr(0,10);
			displayHeaderOnHomepage(mondayDate);
			displayEventsOnHomepage(mondayDate);
		}

		// run when next week button is clicked
		// 
		// does not return anything, but creates and inserts html
		// for the header and event list on the homepage 
		// for the next week from what was being displayed
		function showNextWeek() {
			var currentMonday = getCurrentDate();
			var nextMonday = currentMonday;
			nextMonday.setDate(currentMonday.getDate() + 7);
			mondayDate = nextMonday.toISOString().substr(0,10);
			displayHeaderOnHomepage(mondayDate);
			displayEventsOnHomepage(mondayDate);
		}

		// get the date of what is currently being displayed
		//
		// returns a date of the format yyyy-mm-dd
		function getCurrentDate() {
			var dateHeader = document.getElementsByClassName("events-date")[0].firstElementChild;
			var date = dateHeader.textContent.split("-");
			var d = new Date(date[0] + date[1].substr(-4));
			return d;
		}

	};


	if (bodyHasClass("event_page")){

		rsvpButton = document.getElementsByClassName("reservations")[0].children[1];
		modalExit = document.getElementsByClassName("exit")[0]; 
		modalWindow = document.getElementsByClassName("modal")[0];

		modalExit.addEventListener("click", hideModal);
		rsvpButton.addEventListener("click", showModal);

		// Sets the modal window's display to block.
		function showModal(){
			modalWindow.style.display = "block";
		};

		// Set modal window's display to none.
		function hideModal(){
			modalWindow.style.display = "none";
		};
	};

});





