//to php 


var $=jQuery;

$(window).load(function(){
	
	$(window).resize(function(){
		bannerWidth();
	});
	bannerWidth();
	

	
	//Ãªµã»¬¶¯
	$('a.up[href*=#]').click(function() {
        if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
            var $target = $(this.hash);
            $target = $target.length && $target || $('[name=' + this.hash.slice(1) + ']');
            if ($target.length) {
                var targetOffset = $target.offset().top;
                $('html,body').animate({
                    scrollTop: targetOffset
                },
                500);
                return false;
            }
        }
    });
	
	
	
	/*input*/
	$("span.inputText").parent().css({position:"relative",zIndex:1});
	$("input,textarea").live("keyup focus", function(){
		if($(this).val()){
			$(this).next("span.inputText").hide();
		}else{
			$(this).next("span.inputText").show().css({opacity:0});
		}
	}).live("blur", function(){
		if (!$(this).val()) {
			$(this).next("span.inputText").show().css({opacity:1});
		}
	});
	$("span.inputText").live("click",function(){
		$(this).css({opacity:0});
		$(this).parent().find("input,textarea").focus();
	});
	
	$("input,textarea").each(function(){
		if ($(this).val().length > 0) {
			$(this).next("span.inputText").hide();
		}
	});
	
	
	
});



function bannerWidth() { 
	var browserwidth = $(window).width();
	$(".homebanner .list img.bg,.banner .list img.bg").css({width:browserwidth})
	

	if(browserwidth<1500){
		$(".homebanner .list img.bg,.banner .list img.bg").css({width:"auto"});
	}else{
		$(".homebanner .list img.bg,.banner .list img.bg").css({width:"100%"});
	}
	

	
} 