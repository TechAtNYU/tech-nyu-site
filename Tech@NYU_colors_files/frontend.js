$(document).ready(function() {
		
	$.getJSON("/process/get_sponsors.php", function(response) {
			$.each(response, function(key, value) {
				$(".powered .company").fadeIn(200);
				$(".powered .company").delay(5000).fadeOut(200, function() {
					$(".powered .company").html(value);
				});
			});		
	});
	
	for (var i = 0; i < 100; i++) {
		$(".fancy-banner").append("<div class=\"box\"></div>");
	}
});