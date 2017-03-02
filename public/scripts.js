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

		displayHomepage();

		// get events for a specific week from server 
		// and display them by creating and inserting html
		// on to homepage as a list
		// date is the date of the monday of the week as yyyy-mm-dd
		function displayHomepage(date) {
			var list = new EventList(date)
			list.addEvents();
			list.addHeader();	
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
			displayHomepage(mondayDate);
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
			displayHomepage(mondayDate);
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





