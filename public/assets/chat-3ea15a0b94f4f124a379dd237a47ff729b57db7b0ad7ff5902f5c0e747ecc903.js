function printMessage(e){$("#messages").append(e+"<br>"),$("#chat-input").val(""),$("#messages").animate({scrollTop:$("#messages").get(0).scrollHeight},100)}function get_company_name(e){$.ajax({type:"POST",data:{id:e},url:"/users/get_user_company"}).done(function(a){$(".author_"+e).text(a.company),$(".username_"+e).text(a.company)})}function get_user_company_name(e){$.ajax({type:"POST",data:{id:e},url:"/users/get_user_company"}).done(function(a){$(".username_"+e).text("Welcome "+a.company)})}function get_avatar(e){$.ajax({type:"POST",data:{id:e},url:"/users/get_user_avatar"}).done(function(a){$(".image_"+e).attr("src",a.avatar)})}function update_unread_messages(e,a,n){$.ajax({type:"POST",data:{id:e,tender_id:a,group_name:n},url:"/messages/update_unread_messages"}).done(function(a){$("."+e+"_unread_"+a.message_id).text("")})}var new_channel,chatChannel,sc_id,hc_id,username;jQuery(document).ready(function(){$(function(){function e(){chatChannel.join().then(function(){printMessage('<p class="username_'+username+'">'+get_user_company_name(username)+"</p>")}),chatChannel.on("messageAdded",function(e){get_avatar(e.author);var n=["Jan","Feb","Mar","Apr","May","June","July","Aug","Sept","Oct","Nov","Dec"],t=new Date(e.timestamp),s=t.getDay(),c=t.getMonth(),i=e.timestamp.toLocaleTimeString().replace(/:\d+ /,"")+" "+s+" "+n[c];printMessage(' <div class="row"><div class="col-md-24"><div class="col-md-2"><img src="'+a+'" class="img-circle image_'+e.author+'" width="80px" height="60px"></div><div class="col-md-4"></div><div class="col-md-18"><p class="text-center" style="font-size: 14px;font-weight: bold">'+i+'</p><p style="font-size: 14px;font-weight: bold" class="author_'+e.author+'">'+get_company_name(e.author)+'</p><p style="font-size: 14px">'+e.body+"</p></div></div></div>")}),chatChannel.getMessages(25).then(function(e){for(i=0;i<e.length;i++){var t=e[i];get_avatar(t.author);var s=["Jan","Feb","Mar","Apr","May","June","July","Aug","Sept","Oct","Nov","Dec"],c=new Date(t.timestamp),o=c.getDay(),l=c.getMonth(),d=t.timestamp.toLocaleTimeString().replace(/:\d+ /,"")+" "+o+" "+s[l];printMessage(' <div class="row"><div class="col-md-24"><div class="col-md-2"><img src="'+a+'" class="img-circle image_'+t.author+'" width="80px" height="60px"></div><div class="col-md-4"></div><div class="col-md-18"><p class="text-center" style="font-size: 14px;font-weight: bold">'+d+'</p><p style="font-size: 14px;font-weight: bold" class="author_'+t.author+'">'+get_company_name(t.author)+'</p><p style="font-size: 14px">'+t.body+"</p></div></div></div>"),update_unread_messages(t.author,n,new_channel)}}),chatChannel.on("typingStarted",function(e){console.log("typing started for "+e)})}sc_id=$(".sc_id").val(),hc_id=$(".hc_id").val();var a,n=$(".tender_id").val(),t=($(".trade").val(),$(".trade_name").val()),s=$(".group_chat").attr("alt");new_channel=parseInt(sc_id)>0&&parseInt(hc_id)>0?"channel_"+t+"_"+n+"_"+sc_id+"_"+hc_id:s,console.log("new_channel:"+new_channel),$.post("/token",function(n){a=n.avatar,username=n.username;var t=new Twilio.AccessManager(n.token),s=new Twilio.IPMessaging.Client(t);s.getChannelByUniqueName(new_channel).then(function(a){a?(chatChannel=a,e()):s.createChannel({uniqueName:new_channel,friendlyName:new_channel+"_Channel"}).then(function(a){chatChannel=a,e()})})});var c=$("#chat-input"),o=$(".send");c.on("keydown",function(e){if(13==e.keyCode){var a=$("#chat-input").val();chatChannel.sendMessage(a.toString()),console.log("tender_id:"+n),console.log("new:"+new_channel),console.log("sc_id:"+sc_id),console.log("hc_id:"+hc_id),parseInt(sc_id)>0&&parseInt(hc_id)>0?$.ajax({type:"POST",data:{channel:new_channel,tender_id:n,message:a,sc_id:sc_id,hc_id:hc_id},url:"/messages/save_messages"}).done(function(e){console.log("data:"+e.channel),$('.message_time[alt="'+e.channel+'"]').text(e.message_time),$('.message_text[alt="'+e.channel+'"]').text(e.message_text),update_unread_messages(sc_id,n,e.channel)}):$.ajax({type:"POST",data:{channel:new_channel,tender_id:n,message:a},url:"/messages/save_messages"}).done(function(e){$('.message_time[alt="'+e.channel+'"]').text(e.message_time),$('.message_text[alt="'+e.channel+'"]').text(e.message_text);var a=$(".current_user").val();update_unread_messages(a,n,e.channel)})}}),o.on("click",function(){var e=$("#chat-input").val();chatChannel.sendMessage(e.toString())})})});