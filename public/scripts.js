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





