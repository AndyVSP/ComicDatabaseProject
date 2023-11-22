
<?php
//Connect to database
    $server = 'localhost';
    $username = 'root';
    $password = '';
    $database = 'dc_ro';

    try{
        $conn = new PDO("mysql:host=$server;dbname=$database;", $username,
        $password);
        } catch(PDOException $e){
        die( "Connection failed: " . $e->getMessage());
        }

//Start session
session_start();


//Get list of characters with reading orders
    $get_characters = "SELECT DISTINCT first_name, last_name FROM 
                    (dc_character_reading_order INNER JOIN dc_character 
                    ON dc_character_id = dc_character.id)";
 
    $stmt = $conn->query($get_characters);
    $ro_character_names = $stmt->fetchAll(PDO::FETCH_ASSOC);

//Get list of teams with reading orders
     $get_teams = "SELECT DISTINCT name FROM 
     (team_reading_order INNER JOIN team 
     ON team_id = team.id)";

    $stmt2 = $conn->query($get_teams);
    $ro_team_names = $stmt2->fetchAll(PDO::FETCH_COLUMN);   
        
?>		
      
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>DC Comics Reading Order Database</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel='stylesheet' href="https://fonts.googleapis.com/css2?family=Sigmar+One&display=swap">
        <link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Roboto'>
        <link href="https://fonts.googleapis.com/css2?family=Karma:wght@300&family=Sigmar+One&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
        <link href="/myStyle.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <nav id="header" class= "navbar" style = "background-color:#0476F2;">
            <div id = "logo" class = "container-fluid" style="width: 40%; margin-left: 0;">
                <h1 style= "font-family: Sigmar One, sans-serif; color: #FFFFFF;">DC Comics Reading Order Databse</h1>
            </div>
        </nav>
        <div class="container-fluid" style="margin: 30px;">
            <div class="row">
                <div class="container-fluid">
                    <h2 style="margin: 15px 25px;" >Select Reading Orders</h2>
                </div>
            </div>
            <div class="row"> 
                <div class = "col-3">
                    <div class = "container-fluid">
                        <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Character Reading Orders
                        </button>
                        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>" method="post">
                            <ul id="tag-dropdown" class="dropdown-menu" style="padding: 5px;">
                            <?php foreach ($ro_character_names as $ro_character): ?>
                                <li style="margin: 0 27px 0 0;">
                                    <input name = "ro_char_select[]" class = "form-check-input" type= "checkbox" value="<?php echo $ro_character["first_name"]. " ".$ro_character["last_name"]?>"/>
                                    <label class="form-check-label"><?php echo $ro_character["first_name"], " ",$ro_character["last_name"]?></label>
                                </li>
                            <?php endforeach; ?>
                                <input type="submit" name = "ro_char_submit" value="Submit" style="margin: 0 0 0 150px;">
                            </ul>
                        </form> 
                    </div>  
                </div>
                <div class = "col-3">
                    <div class = "container-fluid">
                        <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Team Reading Orders
                        </button>
                            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>" method="post">
                                <ul id="tag-dropdown" class="dropdown-menu" style="padding: 5px;">
                                <?php foreach ($ro_team_names as $ro_team): ?>
                                    <li style="margin: 0 15px 0 0;">
                                        <input name = "ro_team_select[]" class = "form-check-input" type= "checkbox" value="<?php echo $ro_team?>"/>
                                        <label class="form-check-label"><?php echo $ro_team?></label>
                                    </li>
                                <?php endforeach; ?>
                                    <input type="submit" name = "ro_team_submit" value="Submit" style="margin: 0 0 0 120px;">
                                </ul>
                            </form> 
                    </div> 
                </div> 
            </div>
            <div class = "row">
                <div class = "col-3">
                    <div class= "container-fluid">
                        <p>Character Reading Orders Slected:</p>
                        <?php 
                                if(isset($_POST["ro_char_submit"])){
                                    if(!empty($_POST["ro_char_select"])){
                                        $_SESSION["ro_char_selected"] = (($_POST["ro_char_select"]));
                                        foreach($_POST["ro_char_select"] as $ro_char_selected){
                                            echo $ro_char_selected. "<br>"; }
                                        }
                                    }   
                                    
                                if(isset($_POST["ro_team_submit"])){
                                        if(!empty($_SESSION["ro_char_selected"])){
                                            foreach($_SESSION["ro_char_selected"] as $ro_char_selected){
                                                echo $ro_char_selected. "<br>"; }
                                            }
                                        }  
                        ?>
                    </div>
                </div>
                <div class = "col-3">
                    <div class= "container-fluid">
                        <p>Team Reading Orders Slected:</p>
                        <?php 
                                if(isset($_POST["ro_team_submit"])){
                                    if(!empty($_POST["ro_team_select"])){
                                        $_SESSION["ro_team_selected"] = (($_POST["ro_team_select"]));
                                        foreach($_POST["ro_team_select"] as $ro_team_selected){
                                            echo $ro_team_selected. "<br>"; }
                                        }
                                    }    

                                if(isset($_POST["ro_char_submit"])){
                                    if(!empty($_SESSION["ro_team_selected"])){
                                        foreach($_SESSION["ro_team_selected"] as $ro_team_selected){
                                                echo $ro_team_selected. "<br>"; }
                                        }
                                    } 
                        ?>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
    </body>
</html>