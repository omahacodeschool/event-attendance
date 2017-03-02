window.addEventListener("load", function (){

	// Checks to see if the body tag has a particular class.
	//
	// className - String.
	//
	// returns a boolean (true / false).
	function bodyHasClass(className){
		body = document.getElementsByTagName("body")[0];
		return body.classList.contains(className);
	};

	if (bodyHasClass("index_page")){ 

		var ourRequest = new XMLHttpRequest();
		ourRequest.open('GET', "/eventlist", true);
		ourRequest.onload = addEvents;
		ourRequest.send();

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
			weekdays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
			createHTMLForEachWeekday(data);
			document.getElementsByClassName("events")[0].insertAdjacentHTML('beforeend',htmlToInsert);
		}

		// Creates html for events by each weekday.
		// data - json data as a hash organized as weekday -> array of events.
		// html created as a string for all weekdays.
		function createHTMLForEachWeekday(data) {
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





