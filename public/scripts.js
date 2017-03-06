window.addEventListener("load", function (){

	if (window.innerWidth < 570){
		var lastButtonClicked = "";
		checkForDropDownMenus();
	}
	else{
		
		var modalWindow = document.getElementsByClassName("modal")[0];
		var modalBody = modalWindow.children[0];
		var exit = document.getElementsByClassName("exitModal")[0];
		var trigger = document.getElementsByClassName("modalTrigger")[0];

		modalBody.addEventListener("click", dontBubble);
		trigger.addEventListener("click", openModal);
		modalWindow.addEventListener("click", closeModal);
		exit.addEventListener("click", closeModal);

		// Prevents events bubbling up to parent
		// 
		// e - event
		function dontBubble(e){
			e.stopImmediatePropagation();
		};

		// Sets the modal to display block
		function openModal(){
			modalWindow.style.display = "block";
		};

		// Hides modal
		function closeModal(){
			modalWindow.style.display = 'none';
		};
	};

	// Checks for the number of drop down menus
	function checkForDropDownMenus(){
		var drops = allElementsOfClass("dropDown").length;
		if (drops > 0){
			determineDropMenus(drops)
		};
	};

	// Determines the drop downs from how many thier are
	//
	// numOfMenus - integer
	function determineDropMenus(numOfMenus){
		if(numOfMenus == 2){
			setNoUserDrops();
		}
		else if(numOfMenus == 1){
			setAdminDrops();
		};
	};

	// Adds eventlistener to show the admin's addevent drop menu
	function setAdminDrops(){
		var addEventButton = document.getElementsByClassName("addEvent Button")[0];

		addEventButton.addEventListener("click", dropMenuDown);
	};

	// Sets an eventlistener to show the login/signup menus
	function setNoUserDrops(){
		var loginButton = document.getElementsByClassName("login Button")[0];
		var signupButton = document.getElementsByClassName("signup Button")[0];

		loginButton.addEventListener("click", dropMenuDown);
		signupButton.addEventListener("click", dropMenuDown);
	};

	// Moves the drop menus all up then the active one down, closes all if
	// same button is clicked twice
	function dropMenuDown(){
		moveElementsToTop(allElementsOfClass("dropDown"));
		if (lastButtonClicked == this.classList[0]){
			lastButtonClicked = "";
		}
		else{
			lastButtonClicked = this.classList[0];
			var menu = document.getElementsByClassName(lastButtonClicked)[1];
			var header = document.getElementsByClassName("header_title")[0];
			menu.style.top = windowTopToBottomOf(header) + "px";
		};	
	};

	// Find the pixels from top to bottom of element
	//
	// element - node
	//
	// returns an integer
	function windowTopToBottomOf(element){
		return element.offsetTop + element.offsetHeight;
	};

	// Moves a collection of dom nodes to the top of the page
	//
	// arrayOfElements - array of dom nodes
	function moveElementsToTop(arrayOfElements){
		for (i = 0; i < arrayOfElements.length; i++){
			arrayOfElements[i].style.top = "-80px"
		};
	};

	// Finds elements with a class
	// 
	// className - string
	//
	// returns an array of nodes
	function  allElementsOfClass(className){
		return document.getElementsByClassName(className);
	};

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
			event.preventDefault();
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
			event.preventDefault();
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
		
		var modalExit = document.getElementsByClassName("exit")[0]; 
		var modalWindow = document.getElementsByClassName("modal")[0];
		editOptions = document.getElementsByClassName("editComment")

		modalExit.addEventListener("click", hideModal);

		for (i = 0; i <= editOptions.length -1; i++){
			editOptions[i].addEventListener("click", showEditOptions);	
		}

		// Set modal window's display to none.
		function hideModal(e){
			modalWindow.style.display = "none";
			e.preventDefault()
		};

		function showEditOptions(e){
			modalWindow.style.display = "block";
			document.getElementsByClassName("editText")[0].innerHTML = this.parentElement.childNodes[2].innerHTML
			document.getElementsByClassName("commentId")[0].value = this.id
			e.preventDefault()
		};
	};
});





