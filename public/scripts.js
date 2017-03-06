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

		// displays events for the current week upon initial page load
		displayHomepage();

		// get events for a specific week from server 
		// and display them by creating and inserting html
		// on to homepage as a list
		// date - Date object for a Monday
		function displayHomepage(date = null) {
			var list = new EventList(date);
			list.addHeader();	
			list.addEvents();
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
			var currentMonday = getDisplayedWeekDate();
			var prevMonday = currentMonday;
			prevMonday.setDate(currentMonday.getDate() - 7);
			displayHomepage(prevMonday);
		}

		// run when next week button is clicked
		// 
		// does not return anything, but creates and inserts html
		// for the header and event list on the homepage 
		// for the next week from what was being displayed
		function showNextWeek() {
			var currentMonday = getDisplayedWeekDate();
			var nextMonday = currentMonday;
			nextMonday.setDate(currentMonday.getDate() + 7);
			displayHomepage(nextMonday);
		}

		// get the date of what is currently being displayed
		//
		// returns a Date object
		function getDisplayedWeekDate() {
		  var dateHeader = document.getElementsByClassName("events-date")[0].firstElementChild;
		  var date = dateHeader.textContent.split("-");
		  var d = new Date(date[0] + date[1].substr(-4));
		  return d;
		}

		var updateMeetupsButton = document.getElementsByClassName("button_update_meetups")[0];
		updateMeetupsButton.addEventListener("click", updateMeetups);

		function updateMeetups() {
			ourRequest = new XMLHttpRequest();
			ourRequest.open('GET', "/updateMeetups", true);
			ourRequest.send();
		}

	};


	if (bodyHasClass("event_page")){
		var rsvpButton = document.getElementsByClassName("reservations")[0].children[1];
		var modalExit = document.getElementsByClassName("exit")[0]; 
		var modalWindow = document.getElementsByClassName("modal")[0];

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





