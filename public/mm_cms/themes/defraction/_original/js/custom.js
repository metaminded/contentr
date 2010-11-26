$(function() {
	$('a').hover(function() {
		$(this).children('.front').stop().animate({"opacity": ".1"}, "slow");
	}, function() {
		$(this).children('.front').stop().animate({"opacity": "1"}, "slow");
	});
});