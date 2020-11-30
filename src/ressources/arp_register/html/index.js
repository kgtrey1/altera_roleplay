function PutError(msg)
{
    $("#result").html("<p class='alert alert-danger' role='alert'>"+ msg +"</p>");
}

function IsNumeric(input)
{
    let digits = /^[0-9]+$/;

    if (digits.test(input))
        return (true);
    else
        return (false);
}

function IsAlpha(input)
{
    let letters = /^[a-zA-Z]+$/;

    if (letters.test(input))
        return (true);
    else
        return (false);
}

function VerifyName(input)
{
    if (!IsAlpha(input)) {
        PutError("Les noms ne doivent comporter que des lettres.");
        return (false);
    }
    if (input.lenght < 3 || input.lenght > 16) {
        PutError("Les noms doivent faire entre 3 et 16 caractères.");
        return (false);
    }
    return (true);
}

function VerifyGender(gender)
{
    if (gender.localeCompare("Masculin") != 0 && gender.localeCompare("Féminin") != 0) {
        PutError("Votre genre est invalide.");
        return (false);
    }
    return (true);
}

function VerifyBirthDate(day, month, year)
{
    if (!IsNumeric(day) || !IsNumeric(month) || !IsNumeric(year)) {
        PutError("Votre date de naissance est invalide.");
        return (false);
    }
    if (day < 1 || day > 31 || month < 1 || month > 12) {
        PutError("Votre date de naissance est invalide");
        return (false);
    }
    if (year > 2001 || year < 1950) {
        PutError("Vous êtes trop vieux ou trop jeune.");
        return (false);
    }
    return (true);
}

function VerifyHeight(height)
{
    if (!IsNumeric(height)) {
        PutError("Votre taille ne peut contenir que des chiffres.");
        return (false);
    }
    if (height < 140 || height > 220) {
        PutError("Vous êtes trop grand ou trop petit.")
        return (false);
    }
    return (true);
}

$(function() {
    function SetDisplay(display)
    {
        if (display)
            $("#menu").show();
        else
            $("#menu").hide();
    }
    SetDisplay(false);
    window.addEventListener("message", function(event) {
        var item = event.data;

        if (item.type === "ui") {
            if (item.status)
                SetDisplay(true);
            else
                SetDisplay(false);
        }
    });
    $("#submit").click(function() {
        let firstName = $("#firstname").val();
        let lastName = $("#lastname").val();
        let gender = $("#gender option:selected").text();
        let height = $("#height").val();
        let day = $("#day").val();
        let month = $("#month").val();
        let year = $("#year").val();

        if (!VerifyName(firstName) || !VerifyName(lastName) || !VerifyGender(gender) || !VerifyBirthDate(day, month, year) || !VerifyHeight(height))
            return (false);
        $.post('http://arp_register/main', JSON.stringify({
                firstname: firstName,
                lastname: lastName,
                gender: gender,
                height, height,
                day: day,
                month: month,
                year: year
        }));
    });
});
