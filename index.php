<?php require_once "function/function.php";?>

<!DOCTYPE html>
<html lang="it">
<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>RNDT metadata converter</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="assets/css/style.css"/>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="assets/js/jquery_3.5.1/jquery.min.js"></script>
</head>
<body>

<header>
	<div class="logo"><img src="assets/img/rndt-logo.png" title="RNDT md converter" width="90" height="90"/></a></div>
    <h1>RNDT metadata converter</h1>
</header>

<?php if(!empty(DESCRIPTION)):?>
    <section id="description" class="p25">
        <?php echo DESCRIPTION;?>
    </section>
<?php endif;?>

<!-- Uncomment from <section> to </section> to use the Italian labels in the form -->

<!--<section id="input-box" class="p25">
    <h2 class="bottom20">
        Inserire la richiesta:
    </h2>
    <form id="api" action="transformation.php" method="get">
        <div style="">
            <label class="labelCustom" for="parametervalue">Organizzazione: </label>
            <input id="parametervalue" type="text" name="parametervalue" required>
            <div class="results_PA" style="display: none;"></div>
        </div>
        <p>
            <label class="labelCustom" for="max">Numero record richiesti: </label>
            <input id="max" class="numberCustom" type="number" min="0" max="<?php echo MAX_FILE_REQUEST;?>" name="max" required>
        </p>
        <p>
            <label class="labelCustom" for="start">Numero primo record: </label>
            <input id="start" class="numberCustom" type="number" min="0" name="start" required>
        </p>
        <p><input style="float:right" type="submit" id="transform" value="Trasforma"/></p>
    </form>
    <div id="response" style="display: none;">
        <div id="loadingResponse">
            <div class="lds-default"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div>
        </div>
        <div id="response_success">
            Azione eseguita con successo: <span id="success_message"></span><br>
            <div class="backNewRequest">Nuova richiesta</div>
        </div>
        <div id="response_error">
            Attenzione è avvenuto un errore: <span id="error_message"></span><br>
            <div class="backNewRequest">Nuova richiesta</div>
        </div>
    </div>
</section>-->

<!-- Comment from <section> to </section> to use the Italian labels in the form -->
            
            <section id="input-box" class="p25">
                <h2 class="bottom20">
                    Enter the request:
                </h2>
                <form id="api" action="transformation.php" method="get">
                    <div style="">
                        <label class="labelCustom" for="parametervalue">Organisation name: </label>
                        <input id="parametervalue" type="text" name="parametervalue" required>
                        <div class="results_PA" style="display: none;"></div>
                    </div>
                    <p>
                        <label class="labelCustom" for="max">Max records: </label>
                        <input id="max" class="numberCustom" type="number" min="0" max="<?php echo MAX_FILE_REQUEST;?>" name="max" required>
                    </p>
                    <p>
                        <label class="labelCustom" for="start">Start position: </label>
                        <input id="start" class="numberCustom" type="number" min="0" name="start" required>
                    </p>
                    <p><input style="float:right" type="submit" id="transform" value="Transform"/></p>
                </form>
                <div id="response" style="display: none;">
                    <div id="loadingResponse">
                        <div class="lds-default"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div>
                    </div>
                    <div id="response_success">
                        Action successfully performed: <span id="success_message"></span><br>
                        <div class="backNewRequest">New request</div>
                    </div>
                    <div id="response_error">
                        ATTENTION, an error occurred: <span id="error_message"></span><br>
                        <div class="backNewRequest">New request</div>
                    </div>
                </div>
            </section>

<div class="footer" class="top50">
    <footer>RNDT metadata converter  - GitHub: <a target='_blank' href="https://github.com/AgID/rndt-md-converter">https://github.com/AgID/rndt-md-converter</a></footer>
</div>

</div>


<script>
    $( "#max" ).keyup(function(e){
        if(parseInt(this.value) > <?php echo MAX_FILE_REQUEST;?>){
            this.value = <?php echo MAX_FILE_REQUEST;?>;
        }
        if(parseInt(this.value) < 0){
            this.value = 0;
        }
    });

    $( "#start" ).keyup(function(e){
        if(parseInt(this.value) < 0){
            this.value = 0;
        }
    });



    function cleanAllResponse(){
        $("#api").hide();
        $("#response").hide();
        $("#response_success").hide();
        $("#response_error").hide();
        $("#loadingResponse").hide();

        $("#success_message").html("");
        $("#error_message").html("");
    }

    $(".backNewRequest").click(function(e){
        e.stopPropagation();
        e.preventDefault();

        cleanAllResponse();

        $("#api").show();
    });

    $("#api").submit(function(e){
        e.stopPropagation();
        e.preventDefault();

        cleanAllResponse();

        $("#response").show();
        $("#loadingResponse").show();
        $("#error_message").text("");


        $.ajax({
            method: "POST",
            url: this.action,
            data: {
                max: $("#max").val(),
                start: $("#start").val(),
                parametervalue: encodeURI($("#parametervalue").val())
            }
        }).done(function( json ) {
            $("#loadingResponse").hide();
            try {
                if(json.success){
                    $("#response_success").show();
                    $("#response_error").hide();

                    var link = $("<a>",{href:json.success,text:"Download","class":"linkDownloadCustom"});
                    $("#success_message").append(link);
                }

                if(json.error){
                    $("#response_success").hide();
                    $("#response_error").show();
                    $("#error_message").html(json.error);
                }



            } catch(e) {
                $("#response_success").hide();
                $("#response_error").show();
                $("#error_message").html("An error occurred");

            }
        });

    });

</script>
</body>
</html>
