window.addEventListener("load", function (){

	var params = "id" + eventId;
	var ourRequest = new XMLHttpRequest();
	ourRequest.open('GET', "/userslist", true);
	ourRequest.onload = addRsvps;
	ourRequest.send(params);

	function addRsvps(event) {
		var result = event.target.responseText;

		data = JSON.parse(result);
		
		createHTML(data);		
	}
});



function createHTML(data){
	htmlToInsert = "";
	for (var i=0;i<data.length;i++) {
		firstName = data[i]['first_name'];
		lastName = data[i]['last_name'];

		htmlToInsert += firstName + " " + lastName + "<br>";
	}
	document.getElementsByTagName("body")[0].innerHTML = htmlToInsert;
}