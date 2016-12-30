var new_channel;
var chatChannel;
var sc_id;
var hc_id;
var username;

function printMessage(message) {
    $('#messages').append(message + "<br>");
    $('#chat-input').val('');
    //$('#messages').prop("scrollHeight");
    $('#messages').animate({
        scrollTop: $('#messages').get(0).scrollHeight}, 100);
}

jQuery(document).ready(function () {
    $(function() {


        sc_id = $('.sc_id').val();
        hc_id = $('.hc_id').val();
        var avatar_path;
        var tender_id = $('.tender_id').val();
        var trade = $('.trade').val();

        var trade_name = $('.trade_name').val();
        var group_name = $('.group_chat').attr('alt');
        if(parseInt(sc_id) > 0 && parseInt(hc_id) > 0){
            new_channel = "channel_"+trade_name+"_"+tender_id+"_"+sc_id+"_"+hc_id;
        }else{
            new_channel = group_name;
        }
        console.log("new_channel:"+new_channel);

        $.post("/token", function(data) {

            avatar_path = data.avatar;
            username = data.username;
            var accessManager = new Twilio.AccessManager(data.token);
            var messagingClient = new Twilio.IPMessaging.Client(accessManager);

            messagingClient.getChannelByUniqueName(new_channel).then(function(channel) {
                
                if (channel) {
                    chatChannel = channel;
                    setupChannel();
                } else {
                    messagingClient.createChannel({
                        uniqueName: new_channel,
                        friendlyName: new_channel+"_"+ 'Channel' })
                        .then(function(channel) {
                            chatChannel = channel;
                            setupChannel();
                        });
                }
            });
        });

        function setupChannel() {

            chatChannel.join().then(function(channel) {
                printMessage('<p class="username_'+username+'">'+get_user_company_name(username)+'</p>');
            });

            chatChannel.on('messageAdded', function(message) {

                //printMessage(message.author + ": " + message.body);

                get_avatar(message.author);
                var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec']
                var new_date = new Date(message.timestamp);
                var day = new_date.getDay();
                var month = new_date.getMonth();
                var time = (message.timestamp).toLocaleTimeString().replace(/:\d+ /, '') + ' ' + day + ' ' + months[month];
                printMessage(' <div class="row">'+
                    '<div class="col-md-24">'+
                    '<div class="col-md-2"><img src="'+avatar_path+'" class="img-circle image_'+message.author+'" width="80px" height="60px"></div>'+
                    '<div class="col-md-4"></div>'+
                    '<div class="col-md-18">'+
                    '<p class="text-center" style="font-size: 14px;font-weight: bold">'+time+'</p>'+
                    '<p style="font-size: 14px;font-weight: bold" class="author_'+message.author+'">'+get_company_name(message.author)+'</p>'+
                    '<p style="font-size: 14px">'+message.body+'</p>'+
                    '</div>'+
                    '</div>'+
                    '</div>');
            });

            chatChannel.getMessages(25)
                .then(function(messages) {
                        for (i=0; i<messages.length; i++) {
                            var message = messages[i];
                            get_avatar(message.author);
                            var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec']
                            var new_date = new Date(message.timestamp);
                            var day = new_date.getDay();
                            var month = new_date.getMonth();
                            var time = (message.timestamp).toLocaleTimeString().replace(/:\d+ /, '') + ' ' + day + ' ' + months[month];
                            printMessage(' <div class="row">'+
                                '<div class="col-md-24">'+
                                '<div class="col-md-2"><img src="'+avatar_path+'" class="img-circle image_'+message.author+'" width="80px" height="60px"></div>'+
                                '<div class="col-md-4"></div>'+
                                '<div class="col-md-18">'+
                                '<p class="text-center" style="font-size: 14px;font-weight: bold">'+time+'</p>'+
                                '<p style="font-size: 14px;font-weight: bold" class="author_'+message.author+'">'+get_company_name(message.author)+'</p>'+
                                '<p style="font-size: 14px">'+message.body+'</p>'+
                                '</div>'+
                                '</div>'+
                                '</div>');
                            update_unread_messages(message.author,tender_id,new_channel);
                        }
                    }
                );

            chatChannel.on('typingStarted', function(member) {
                //process the member to show typing
                console.log("typing started for " + member);
            });


        }

        var $input = $('#chat-input');
        var $button = $('.send');
        $input.on('keydown', function(e) {
            
            if (e.keyCode == 13) {

                    var message = $('#chat-input').val();
                    chatChannel.sendMessage(message.toString());


                    console.log("tender_id:"+tender_id);
                    console.log("new:"+new_channel);
                    console.log("sc_id:"+sc_id);
                    console.log("hc_id:"+hc_id);

                if(parseInt(sc_id) > 0 && parseInt(hc_id) > 0){
                    $.ajax({
                        type: "POST",
                        data: ({ channel : new_channel,tender_id:tender_id,message:message,sc_id:sc_id,hc_id:hc_id}),
                        url: "/messages/save_messages"
                    }).done(function (data) {
                       console.log("data:"+data.channel);
                        $('.message_time[alt="'+data.channel+'"]').text(data.message_time);
                        $('.message_text[alt="'+data.channel+'"]').text(data.message_text);
                        update_unread_messages(sc_id,tender_id,data.channel);
                    });
                }else{
                    $.ajax({
                        type: "POST",
                        data: ({ channel : new_channel,tender_id:tender_id,message:message}),
                        url: "/messages/save_messages"
                    }).done(function (data) {
                        $('.message_time[alt="'+data.channel+'"]').text(data.message_time);
                        $('.message_text[alt="'+data.channel+'"]').text(data.message_text);
                        var user = $('.current_user').val();
                        update_unread_messages(user,tender_id,data.channel);
                    });
                }
            }
        });

        $button.on('click', function(e) {
            var message = $('#chat-input').val();
            chatChannel.sendMessage(message.toString());
        });

    });

})

function get_company_name(id){

    $.ajax({
        type: "POST",
        data: ({ id : id}),
        url: "/users/get_user_company"
    }).done(function (data) {
     $('.author_'+id).text(data.company);
     $('.username_'+id).text(data.company);
    });
}

function get_user_company_name(id){

    $.ajax({
        type: "POST",
        data: ({ id : id}),
        url: "/users/get_user_company"
    }).done(function (data) {
        $('.username_'+id).text('Welcome ' + data.company);
    });
}

function get_avatar(id){

    $.ajax({
        type: "POST",
        data: ({ id : id}),
        url: "/users/get_user_avatar"
    }).done(function (data) {
        $('.image_'+id).attr("src", data.avatar);
    });
}

function update_unread_messages(id,tender_id,group_name){

    $.ajax({
        type: "POST",
        data: ({ id : id,tender_id:tender_id,group_name : group_name}),
        url: "/messages/update_unread_messages"
    }).done(function (data) {
        $('.'+id+'_'+'unread_'+data.message_id).text('');
    });
}


;
