<?php

// Enter the email you want messages from the
// contact us section to be sent to in the
// variable below:

$email = "email@example.com";

// Do not edit the PHP code below... it is
// for the contact us form

$form_status = 0;
if(isset($_POST['a'])){
    if($_POST['name'] == "" || $_POST['email'] == "" || $_POST['subject'] == "" || $_POST['message'] == "") {
        $form_status = 1;
    } elseif(!preg_match('/^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$/',$_POST['email'])){
        $form_status = 2;
    } else {
        $to      = $email;
        $subject = 'Contact Us';
        $message = "Name: " . $_POST['name'] . "

Email: " . $_POST['email'] . "

Subject: " . $_POST['subject'] . "

Message:
" . $_POST['message'];
        $headers = 'From: ' . $_POST['email'] . "\r\n" .
                   'Reply-To: ' . $_POST['email'] . "\r\n" .
                   'X-Mailer: PHP/' . phpversion();
        mail($to, $subject, $message, $headers);
        $form_status = 3;
    }
}

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Defraction HTML Portfolio/Business Template</title>
<style type="text/css">
@import url('css/style.css');
@import url('css/superfish.css');
@import url('css/nivo-slider.css');
</style>
<!--[if IE 7]>
<style type="text/css">
@import url('css/ie7style.css');
</style>
<![endif]-->
<!--[if IE 8]>
<style type="text/css">
@import url('css/ie8style.css');
</style>
<![endif]--> 
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/jquery.nivo.slider.pack.js"></script>
<script type="text/javascript" src="js/jquery.bxSlider.min.js"></script>
<script type="text/javascript" src="js/jquery.prettyPhoto.js"></script>
<script type="text/javascript" src="js/hoverIntent.js"></script> 
<script type="text/javascript" src="js/superfish.js"></script>
<script type="text/javascript"> 
jQuery(function(){
	jQuery('ul.sf-menu').superfish();
});
$(window).load(function() {
	$('.slider').nivoSlider();
});
$(document).ready(function(){
	$('#bx').bxSlider({
		pager: true,
		auto: true,
		speed: 700,
		pause: 5000
	});
});
$(document).ready(function(){
	$("a[rel^='prettyPhoto']").prettyPhoto();
});
</script>
</head>

<body>
<!-- START HEADER AREA -->
<div id="header">

	<!-- Start Logo -->
	<div id="logo">
    	<a href="index.html"><img src="images/logo.gif" alt="Defraction" /></a>
    </div>
    
    <!-- Start searchbar -->
    <div id="search">
    	<input type="text" class="searchinput" value="Search the site..." onfocus="if (this.value == 'Search the site...') {this.value = '';}" onblur="if (this.value == '') {this.value = 'Search the site...';}" /><input type="submit" value="" class="searchsubmit" />
    </div>
    
    <!-- Start page navigation -->
    <div id="navigation">
		<ul class="sf-menu"> 
			<li> 
				<a href="index.html"><strong>Home</strong><span>homepage</span></a>
                <ul>
                	<li><a href="index.html">Home Style 1</a></li>
                    <li><a href="index-two.html">Home Style 2</a></li>
                </ul>
			</li> 
			<li> 
				<a href="services.html"><strong>Services</strong><span>what we do</span></a> 
                <ul> 
					<li> 
						<a href="default.html">Standard Layout</a> 
					</li>
                    <li>
                    	<a href="footer-threecolumn.html">Three Column Footer</a>
                    </li>
                    <li>
                    	<a href="#">Sub Menu 1</a>
                        <ul>
                        	<li><a href="#">Sub Menu 2</a></li>
                        </ul>
                    </li>
                </ul>
			</li> 
			<li> 
				<a href="portfolio.html"><strong>Portfolio</strong><span>our work</span></a>
                <ul>
                	<li>
                    	<a href="portfolio.html">Portfolio Style 1</a>
                    </li>
                	<li>
                    	<a href="portfolio-onecolumn.html">Portfolio Style 2</a>
                    </li>
                    <li>
                    	<a href="detailed.html">Detailed Portfolio</a>
                    </li>
                </ul>
			</li> 
			<li> 
				<a href="about.html"><strong>About Us</strong><span>our story</span></a> 
			</li>
            <li> 
				<a href="blog.html"><strong>Blog</strong><span>get updated</span></a>
                <ul> 
					<li> 
						<a href="blog.html">Blog Index</a> 
					</li> 
					<li> 
						<a href="single.html">Blog Post</a> 
					</li> 
                </ul>
			</li>	
            <li> 
				<a href="contact.php"><strong>Contact Us</strong><span>get in touch</span></a> 
			</li>	
		</ul> 
	</div>
</div>
<!-- END HEADER AREA -->

<!-- START CONTENT AREA -->
<div class="container">

	<!-- Start breadcrumbs section -->
	<div class="breadcrumbs">
    	<a href="index.html">Home</a> &raquo; Contact Us
    </div>
    
    <!-- Sub top for content area top image -->
	<div id="sub-top">
	</div>
    
    <!-- Start content/sidebar -->
	<div id="sub-content">
    	
        <!-- Start content section left of sidebar -->
		<div id="content">
        
        	<h1>Contact Us</h1>
            <p>Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, <a href="#">tempor sit</a> amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.</p>
            
        	<?php
if($form_status != 0) {
    switch ($form_status) {
        case 1:
            $response = "<p><span class=\"ast\">You must fill in all fields marked with an asterisk.</span></p>";
            break;
        case 2:
            $response = "<p><span class=\"ast\">You must enter a valid email address.</span></p>";
            break;
        case 3:
            $response = "<font color=\"green\">Thank you for your message. You will receive a response within 12 hours.</font>";
            break;
    }
?>
                <p><?php print $response; ?></p>
<?php
}
?>
            	<form action="" method="post" id="contactForm">
                    <input type="hidden" name="a" value="1" />
           			<label for="name">Your name: <span class="ast">*</span></label>
            		<input name="name" type="text" class="c-input" value="<?php if($form_status != 0 && $form_status != 3) {  print htmlspecialchars($_POST['name']); } ?>" /><br />
            		<label for="email">Your email address: <span class="ast">*</span></label>
            		<input name="email" type="text" class="c-input" value="<?php if($form_status != 0 && $form_status != 2 && $form_status != 3) { print htmlspecialchars($_POST['email']); } ?>" /><br />
            		<label for="subject">Subject: <span class="ast">*</span></label>
            		<input name="subject" type="text" class="c-input" value="<?php if($form_status != 0 && $form_status != 3) {  print htmlspecialchars($_POST['subject']); } ?>" /><br />
            		<label for="message">Your message: <span class="ast">*</span></label>
            		<textarea name="message" class="t-message" rows="5" cols="40"><?php if($form_status != 0 && $form_status != 3) {  print htmlspecialchars($_POST['message']); } ?></textarea><br />
            		<input type="submit" class="submit" value="Send Message" />
               </form>
            
        </div><!-- End Content -->
        
        <!-- START THE SIDEBAR -->
        <div id="sidebar">
        	<h3>Sub Navigation</h3>
            	<ul>
                	<li><a href="portfolio.html">Portfolio</a></li>
                    <li><a href="portfolio-onecolumn.html">Portfolio Style 2</a></li>
                    <li><a href="detailed.html">Detailed Portfolio Page</a></li>
                    <li><a href="blog.html">Blog</a></li>
                    <li><a href="single.html">Singe Blog Post</a></li>
                    <li><a href="footer-threecolumn.html">Three Column Footer</a></li>
                    <li><a href="fullwidth.html">Fullwidth Page</a></li>
                </ul>
                
             <!-- Divide sections -->
            <div class="divider"></div>
            
            <h3>From Our Portfolio</h3>
           	<div class="featured">
            	<a href="portfolio.html"><img src="images/featured.png" alt="Defraction HTML Template" /></a>
            </div>
            <p><a href="portfolio.html">View More &raquo;</a></p>
            
            <!-- Divide sections -->
            <div class="divider"></div>
            
            <h3>Some Heading</h3>
            <p>Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.</p>
            
        </div>
	</div>
    
    <!-- Sub bottom for content area bottom image -->
	<div id="sub-bottom">
	</div>
</div>
<!-- END CONTENT AREA -->


	

<!-- START FOOTER AREA -->
<div id="footer-wrap">
	<div id="footer">
    	<!-- Start first column out of four -->
    	<div class="one-fourth">
        	<h4>Lorem Ipsum</h4>
            <ul>
            	<li><a href="index.html">Home</a></li>
                <li><a href="services.html">Services</a></li>
                <li><a href="portfolio.html">Portfolio</a></li>
                <li><a href="blog.html">Blog</a></li>
                <li><a href="about.html">About</a></li>
            </ul>
        </div>
        
        <!-- Start second column -->
        <div class="one-fourth">
        	<h4>Lorem Ipsum</h4>
            <ul>
            	<li><a href="#">Pellentesque habitant</a></li>
                <li><a href="#">Vestibulum tortor quam</a></li>
                <li><a href="#">Mauris placerat</a></li>
                <li><a href="#">Donec eu libero</a></li>
                <li><a href="#">Lorem Ipsum</a></li>
            </ul>
        </div>
        
        <!-- Start third column -->
        <div class="one-fourth">
        	<h4>Contact Us</h4>
            <p>Denver Office Headquarters<br />
5830 West 37th Place<br />
Los Angeles, CA 80201</p>

<p>Tel: +1-723-452-4920<br />
Fax: +1-723-452-4920</p>

<p>hello@yourdomain.com</p>
        </div>
        
        <!-- Start fourth column -->
        <div class="one-fourth-last">
        	<h4>Our Newsletter</h4>
            <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry.</p>
            <form action="" method="get">
            	<input type="text" value="Your email address..." class="newsinput" onfocus="if (this.value == 'Your email address...') {this.value = '';}" onblur="if (this.value == '') {this.value = 'Search email address...';}" /><br />
                <input type="submit" class="newssubmit" value="Sign Up" />
            </form>
        </div>
    </div>
    
    <!-- Start bottom footer -->
    <div id="bottom-footer">
    	<!-- Set container to make with 960px -->
    	<div class="container">
    		<div class="three-fourths">
        		<p>Copyright &copy; 2010 Caden Grant - All Rights Reserved</p>
        	</div>
        	<div class="one-fourth-last">
        		<ul class="social">
                	<li><a href="#"><img src="images/komodomedia_32/facebook_32.png" alt="Connect With Us On Facebook" /></a></li>
                    <li><a href="#"><img src="images/komodomedia_32/twitter_32.png" alt="Connect With Us On Facebook" /></a></li>
                    <li><a href="#"><img src="images/komodomedia_32/flickr_32.png" alt="Connect With Us On Facebook" /></a></li>
                    <li><a href="#"><img src="images/komodomedia_32/linkedin_32.png" alt="Connect With Us On Facebook" /></a></li>
                </ul>
        	</div>
        </div>
    </div>
    <!-- end bottom footer -->
    
</div>
<!-- END FOOTER AREA -->
</body>
</html>
