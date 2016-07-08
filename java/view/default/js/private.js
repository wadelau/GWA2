var $=jQuery;
$(document).ready(function(){
	if (window.PIE) {
		$('.ieFix').each(function() {
			PIE.attach(this);
		});
	}
	
  // sub menu 
	$(".h_box .menu > ul > li").hover(function(){
		$(this).addClass("selected");
		$(this).find("a").eq(0).addClass("hover");
		$(this).find(".submenu").show();
	},function(){
		$(this).removeClass("selected");
		$(this).find("a").eq(0).removeClass("hover");
		$(this).find(".submenu").hide();
	});
 
	$("#promptBox a.btn_close").click(function(){
    $(this).parents("#promptBox").fadeOut(500,
      function(){
        $(".news").show(); //css('z-index','9');
        $(".news_cnt").hide();
      });
	});
  
  $(".news .content .cont a.btn_show").click(function(){
    var clicked = $(this).attr('href').match('[^#/]+$');
    //clicked = parseInt(clicked, 10);
    //$('.navBox .cont a.current', $(this).parentNode).removeClass('current');
    //$('.navBox .cont a:eq(' + clicked + ')', $(this).parentNode).addClass('current');

    $('.news_cnt').children().hide();
    $(".news").hide(); //css('z-index','-999');
    $(".news_cnt").show();
    
    $('.news_cnt').children(':eq(' + clicked + ')').fadeIn(500);
  });

	$("#topicTab a").each(function(i){
		$(this).click(function(){
			$(this).addClass("selected").siblings("a").removeClass("selected");
			$(".topicList .topic").eq(i).show().siblings(".topic").hide();
		})
	})

  $("#prompt2 a.btn_close").click(function(){
    document.getElementById('back').parentNode.removeChild(document.getElementById('back'));
    $(this).parents("#prompt2").fadeOut(500,
    function(){
      $("#prompt2").hide();
    });
  });

  $("#win_show2 a").each(function(i){
  $(this).click(function(){
    var bWidth=parseInt(document.documentElement.scrollWidth);
    var bHeight=parseInt(document.documentElement.scrollHeight);
    var back=document.createElement("div");
    back.id="back";
    var styleStr="z-index:9;top:0px;left:0px;position:absolute;background:#666;width:"+bWidth+"px;height:"+bHeight+"px;";
    styleStr+=(document.all)?"filter:alpha(opacity=0.5);":"opacity:0.5;";
    back.style.cssText=styleStr;
    document.body.appendChild(back);
    $("#prompt2").fadeIn(300);
  })
  });

  $("#prompt a.btn_close").click(function(){
    document.getElementById('back').parentNode.removeChild(document.getElementById('back'));
    $(this).parents("#prompt").fadeOut(500,
    function(){
      $("#prompt").hide();
      $("#step1").show();
      $("#step2").hide();
      $("#step3").hide();
    });
  });
  
  $("#prompt a.forgot_pwd").click(function(){
    $("#step1").hide();
    $("#step2").show();
    $("#step3").hide();
  });

  $("#prompt #reset_pwd").click(function(){
    $("#step1").hide();
    $("#step2").hide();
    $("#step3").show();
  });

  $("#win_show").click(function(){
    var bWidth=parseInt(document.documentElement.scrollWidth);
    var bHeight=parseInt(document.documentElement.scrollHeight);
    var back=document.createElement("div");
    back.id="back";
    var styleStr="z-index:9;top:0px;left:0px;position:absolute;background:#666;width:"+bWidth+"px;height:"+bHeight+"px;";
    styleStr+=(document.all)?"filter:alpha(opacity=0.5);":"opacity:0.5;";
    back.style.cssText=styleStr;
    document.body.appendChild(back);
    $("#prompt").fadeIn(300);
  });
});

function showPreview(source) {  
    var file = source.files[0];  
    if(window.FileReader) {  
        var fr = new FileReader();  
        fr.onloadend = function(e) {  
            document.getElementById("picture_file").src = e.target.result;  
        };  
        fr.readAsDataURL(file);  
    }  
}