$(document).ready(function() {
    window.addEventListener('message', function( event ) {
        if (event.data.action == 'open') {
            var type        = event.data.type;
            var userData    = event.data.array[0];

            if (type == 'driving' || type == 'id') {
                $('img').show();
                $('#name').css('color', '#282828');
                if (userData.gender.toLowerCase() == 'm' ) {
                    $('img').attr('src', 'assets/images/male.png');
                    $('#sex').text('Homme');
                }
                else {
                    $('img').attr('src', 'assets/images/female.png');
                    $('#sex').text('female');
                }
                $('#name').text(userData.firstname + ' ' + userData.lastname);
                $('#dob').text(userData.dateofbirth);
                $('#height').text(userData.height);
                $('#signature').text(userData.firstname + ' ' + userData.lastname);
                if (type == 'driving') {
                    if (userData.bike)
                        $('#licenses').append('<p>Moto</p>');
                    if (userData.truck)
                        $('#licenses').append('<p>Poids lourd</p>');
                    if (userData.car)
                        $('#licenses').append('<p>Voiture</p>');
                    $('#id-card').css('background', 'url(assets/images/license.png)');
                }
                else
                    $('#id-card').css('background', 'url(assets/images/idcard.png)');
            }
            else if (type == 'weapon') {
                $('img').hide();
                $('#name').css('color', '#d9d9d9');
                $('#name').text(userData.firstname + ' ' + userData.lastname);
                $('#dob').text(userData.dateofbirth);
                $('#signature').text(userData.firstname + ' ' + userData.lastname);
                $('#id-card').css('background', 'url(assets/images/firearm.png)');
            }
            $('#id-card').show();
        }
        else if (event.data.action == 'close') {
            $('#name').text('');
            $('#dob').text('');
            $('#height').text('');
            $('#signature').text('');
            $('#sex').text('');
            $('#id-card').hide();
            $('#licenses').html('');
        }
    });
});