
<?php
//Start session
session_start();

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


//Get list of characters with reading orders
    $get_ro_characters = "SELECT DISTINCT first_name, last_name FROM 
    (dc_character_reading_order INNER JOIN dc_character 
    ON dc_character_id = dc_character.id)
    ORDER by first_name";
 
    $stmt = $conn->query($get_ro_characters);
    $ro_character_names = $stmt->fetchAll(PDO::FETCH_ASSOC);

//Get list of teams with reading orders
     $get_ro_teams = "SELECT DISTINCT name FROM 
     (team_reading_order INNER JOIN team 
     ON team_id = team.id)
     ORDER BY name";

    $stmt2 = $conn->query($get_ro_teams);
    $ro_team_names = $stmt2->fetchAll(PDO::FETCH_COLUMN);   

//Get list of events with reading orders
    $get_ro_events = "SELECT DISTINCT name FROM 
    (crossover_event_reading_order INNER JOIN crossover_event
    ON crossover_event_id = crossover_event.id)
    ORDER BY name";

    $stmt3 = $conn->query($get_ro_events);
    $ro_event_names = $stmt3->fetchAll(PDO::FETCH_COLUMN);   

//Get list of continuities with reading orders
    $get_ro_continuities = "SELECT DISTINCT name FROM 
    (continuity_reading_order INNER JOIN continuity
    ON continuity_id = continuity.id)";

    $stmt4 = $conn->query($get_ro_continuities);
    $ro_continuity_names = $stmt4->fetchAll(PDO::FETCH_COLUMN); 

//Get list of all continuities 

$get_continuities = "SELECT name FROM  continuity";
$stmt5 = $conn->query($get_continuities);
$continuity_names = $stmt5->fetchAll(PDO::FETCH_COLUMN); 

//Get list of all issues in the databases
$get_db_issue_count = "SELECT COUNT(issue.id) FROM issue";
$stmt14 =  $conn->query($get_db_issue_count);
$db_issues = $stmt14->fetchAll(PDO::FETCH_COLUMN);

//Intialize variable

$selected_continuity = "";
$selected_continuity = $_GET['continuity'] ?? '';

//Set Session variables when ro_submit is pressed

if(isset($_POST["ro_submit"])){ 
    $_SESSION["name_list"] = [];
    $_SESSION["lname_list"] = [];
    $_SESSION["team_list"] = [];
    $_SESSION["event_list"] = [];
    $_SESSION["continuity_list"] = [];
    if (!empty($_SESSION["ro_char_selected"])) {
        foreach($_SESSION["ro_char_selected"] as $ro_char) {
            $char_name = explode(" ",($ro_char));
            $name = $char_name[0];
            $lname = $char_name[1];
            array_push($_SESSION["name_list"], $name);
            array_push($_SESSION["lname_list"], $lname);
                                            }}
    if (!empty($_SESSION["ro_team_selected"])){
        foreach($_SESSION["ro_team_selected"] as $ro_team) {
            array_push($_SESSION["team_list"], $ro_team);
        }}
    if (!empty($_SESSION["ro_event_selected"])){
        foreach($_SESSION["ro_event_selected"] as $ro_event) {
            array_push($_SESSION["event_list"], $ro_event);
        }}
    if (!empty($_SESSION["ro_continuity_selected"])){
        foreach($_SESSION["ro_continuity_selected"] as $ro_cont) {
            array_push($_SESSION["continuity_list"], $ro_cont);
         }}
         }


///clear session variables when clear button is pressed//

if(isset($_POST["ro_clear"])){ 
    $_SESSION["ro_continuity_selected"] = "";
    $_SESSION["ro_event_selected"] = "";
    $_SESSION["ro_team_selected"] = "";
    $_SESSION["ro_char_selected"] = "";
    $_SESSION["name_list"] = [];
    $_SESSION["lname_list"] = [];
    $_SESSION["team_list"] = [];
    $_SESSION["event_list"] = [];
    $_SESSION["continuity_list"] = [];
}


///get list of issues

if((empty($_SESSION["name_list"])) && (empty($_SESSION["lname_list"])) && (empty($_SESSION["team_list"])) && (empty($_SESSION["event_list"])) && (empty($_SESSION["continuity_list"]))){

    if(!empty($selected_continuity)){
        $get_issues = "SELECT DISTINCT issue.id, issue.number,  is_anthology, has_backup, publication_year, publication_date, cover_date, series.title, continuity.name FROM ((((continuity
        INNER JOIN story ON continuity.id = continuity_id)
        INNER JOIN has_story ON story.id = story_id)
        INNER JOIN issue ON issue_id = issue.id)
        INNER JOIN series ON series_id = series.id)
        WHERE continuity.name = '$selected_continuity'
        ORDER BY publication_date";

        $get_ro_issue_count =  "SELECT COUNT(DISTINCT issue.id) as issue_count FROM issue
        INNER JOIN has_story ON issue_id = issue.id
        INNER JOIN story ON story_id = story.id
        INNER JOIN continuity ON continuity_id = continuity.id
        WHERE continuity.name = '$selected_continuity'" ;
        

    } else{
        $get_issues = "SELECT issue.id, issue.number, is_anthology, has_backup, publication_year, publication_date, cover_date, series.title FROM 
        (issue INNER JOIN series ON series_id = series.id) ORDER BY publication_date";

        $get_ro_issue_count = "SELECT COUNT(issue.id) as issue_count FROM issue";
    }

   
}else {
    $name_string = implode("','", $_SESSION["name_list"]);
    $lname_string = implode("','", $_SESSION["lname_list"]);
    $team_string = implode("','", $_SESSION["team_list"]);
    $event_string = implode("','", $_SESSION["event_list"]);
    $continuity_string = implode("','", $_SESSION["continuity_list"]);

    if(!empty($selected_continuity)){
        $get_issues = "SELECT DISTINCT issue.id,issue.number, is_anthology, has_backup, publication_year, YEAR(publication_date) AS issue_year, publication_date, cover_date, series.title FROM 
        ((((((((((((((continuity 
            INNER JOIN story ON story.continuity_id = continuity.id)
            INNER JOIN has_story ON story_id = story.id)
            INNER JOIN issue ON has_story.issue_id = issue.id)
            INNER JOIN series ON series_id = series.id)
            INNER JOIN in_reading_order ON in_reading_order.issue_id = issue.id)
            INNER JOIN reading_order ON in_reading_order.reading_order_id = reading_order.id)
            LEFT JOIN dc_character_reading_order ON dc_character_reading_order.reading_order_id = reading_order.id)
            LEFT JOIN dc_character ON dc_character_id = dc_character.id)
            LEFT JOIN team_reading_order ON team_reading_order.reading_order_id = reading_order.id)
            LEFT JOIN team ON team_id = team.id)
            LEFT JOIN crossover_event_reading_order ON crossover_event_reading_order.reading_order_id = reading_order.id)
            LEFT JOIN crossover_event ON crossover_event_reading_order.crossover_event_id = crossover_event.id)
            LEFT JOIN continuity_reading_order ON continuity_reading_order.reading_order_id = reading_order.id)
            LEFT JOIN continuity AS ro_conti ON continuity_reading_order.continuity_id = ro_conti.id)
            WHERE ((dc_character.first_name IN ('$name_string') AND dc_character.last_name IN ('$lname_string'))
            OR team.name IN ('$team_string')
            OR crossover_event.name IN ('$event_string')
            OR ro_conti.name IN ('$continuity_string'))
            AND continuity.name = '$selected_continuity'
            ORDER BY issue_year, reading_order.id, position";

        $get_ro_issue_count = "SELECT COUNT(DISTINCT issue.id) FROM 
        ((((((((((((((continuity 
            INNER JOIN story ON story.continuity_id = continuity.id)
            INNER JOIN has_story ON story_id = story.id)
            INNER JOIN issue ON has_story.issue_id = issue.id)
            INNER JOIN series ON series_id = series.id)
            INNER JOIN in_reading_order ON in_reading_order.issue_id = issue.id)
            INNER JOIN reading_order ON in_reading_order.reading_order_id = reading_order.id)
            LEFT JOIN dc_character_reading_order ON dc_character_reading_order.reading_order_id = reading_order.id)
            LEFT JOIN dc_character ON dc_character_id = dc_character.id)
            LEFT JOIN team_reading_order ON team_reading_order.reading_order_id = reading_order.id)
            LEFT JOIN team ON team_id = team.id)
            LEFT JOIN crossover_event_reading_order ON crossover_event_reading_order.reading_order_id = reading_order.id)
            LEFT JOIN crossover_event ON crossover_event_reading_order.crossover_event_id = crossover_event.id)
            LEFT JOIN continuity_reading_order ON continuity_reading_order.reading_order_id = reading_order.id)
            LEFT JOIN continuity AS ro_conti ON continuity_reading_order.continuity_id = ro_conti.id)
            WHERE ((dc_character.first_name In ('$name_string') AND dc_character.last_name in ('$lname_string'))
            OR team.name IN ('$team_string')
            OR crossover_event.name IN ('$event_string')
            OR ro_conti.name IN ('$continuity_string'))
            AND continuity.name = '$selected_continuity'";

    }else
    {
        $get_issues = "SELECT DISTINCT issue.id,issue.number, is_anthology, has_backup, publication_year, YEAR(publication_date) AS issue_year, publication_date, cover_date, series.title FROM 
    (((((((((((issue 
        INNER JOIN series ON series_id = series.id)
        INNER JOIN in_reading_order ON issue_id = issue.id)
        INNER JOIN reading_order ON in_reading_order.reading_order_id = reading_order.id)
        LEFT JOIN dc_character_reading_order ON dc_character_reading_order.reading_order_id = reading_order.id)
        LEFT JOIN dc_character ON dc_character_id = dc_character.id)
        LEFT JOIN team_reading_order ON team_reading_order.reading_order_id = reading_order.id)
        LEFT JOIN team ON team_id = team.id)
        LEFT JOIN crossover_event_reading_order ON crossover_event_reading_order.reading_order_id = reading_order.id)
        LEFT JOIN crossover_event ON crossover_event_id = crossover_event.id)
        LEFT JOIN continuity_reading_order ON continuity_reading_order.reading_order_id = reading_order.id)
        LEFT JOIN continuity ON continuity_id = continuity.id)
        WHERE team.name IN ('$team_string')
        OR crossover_event.name IN ('$event_string')
        OR continuity.name IN ('$continuity_string')
        OR (dc_character.first_name in ('$name_string') AND dc_character.last_name IN ('$lname_string'))
        ORDER BY issue_year, reading_order.id, position";

    $get_ro_issue_count = "SELECT COUNT(DISTINCT issue.id) FROM 
    (((((((((((issue 
        INNER JOIN series ON series_id = series.id)
        INNER JOIN in_reading_order ON issue_id = issue.id)
        INNER JOIN reading_order ON in_reading_order.reading_order_id = reading_order.id)
        LEFT JOIN dc_character_reading_order ON dc_character_reading_order.reading_order_id = reading_order.id)
        LEFT JOIN dc_character ON dc_character_id = dc_character.id)
        LEFT JOIN team_reading_order ON team_reading_order.reading_order_id = reading_order.id)
        LEFT JOIN team ON team_id = team.id)
        LEFT JOIN crossover_event_reading_order ON crossover_event_reading_order.reading_order_id = reading_order.id)
        LEFT JOIN crossover_event ON crossover_event_id = crossover_event.id)
        LEFT JOIN continuity_reading_order ON continuity_reading_order.reading_order_id = reading_order.id)
        LEFT JOIN continuity ON continuity_id = continuity.id)
        WHERE team.name IN ('$team_string')
        OR crossover_event.name IN ('$event_string')
        OR continuity.name IN ('$continuity_string')
        OR (dc_character.first_name in ('$name_string') AND dc_character.last_name IN ('$lname_string'))";

               
    }
   
}


$stmt6 = $conn->query($get_issues);
$issues_info = $stmt6->fetchAll(PDO::FETCH_ASSOC);

$stmt15 = $conn->query($get_ro_issue_count);
$ro_issues = $stmt15->fetchAll(PDO::FETCH_COLUMN);

?>	
    
   

<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>DC Reading Order Database</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel='stylesheet' href="https://fonts.googleapis.com/css2?family=Sigmar+One&display=swap">
        <link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Roboto'>
        <link href="https://fonts.googleapis.com/css2?family=Karma:wght@300&family=Sigmar+One&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    </head>
    <body>
        <!-- HEADER START-->
 
        <nav id="header" class= "navbar" style = "background-color:#0476F2;">
            <div id = "logo" class = "container-fluid" style="width: 40%; margin-left: 0;">
                <h1 style= "font-family: Sigmar One, sans-serif; color: #FFFFFF;">DC Reading Order Database</h1>
            </div>
        </nav>
         <!-- HEADER END-->
        <!-- MAIN BODY START-->
        <div class="container-fluid">
            <!-- READING ORDER SELECTOR STAR-->
            <div class="row">
                <div class="container-fluid">
                    <h2 style="margin: 15px 25px;" >Select Reading Orders</h2>
                </div>
            </div>
            <div class="row" stle= "margin: 10px;">
                 <!-- CHARACTER RO SELECTOR START-->
                <div class = "col-3">
                    <div class = "container-fluid">
                        <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" style="width: 100%; font-family: Roboto, sans-serif;">
                            Character Reading Orders
                        </button>
                        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>" method="post">
                            <ul id="tag-dropdown" class="dropdown-menu" style="padding: 5px; background-color: #E6F1FE;">
                            <?php foreach ($ro_character_names as $ro_character): ?>
                                <li style="margin: 5px; width: 305px; font-size: 17px; font-family: Karma, sans-serif;">
                                    <input name = "ro_char_select[]" class = "form-check-input" type= "checkbox" value="<?php echo $ro_character["first_name"]. " ".$ro_character["last_name"]?>"/>
                                    <label class="form-check-label"><?php echo $ro_character["first_name"], " ",$ro_character["last_name"]?></label>
                                </li>
                            <?php endforeach; ?>
                                <br>
                                <input type="submit" name = "ro_char_submit" value="Select" class = "btn btn-secondary" style="margin: 0 0 0 220px; font-family: Roboto, sans-serif;">
                            </ul>
                        </form> 
                    </div>  
                </div>
                 <!-- CHARACTER RO SELECTOR END-->
                 <!-- TEAM RO SELECTOR START-->
                <div class = "col-3">
                    <div class = "container-fluid">
                        <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" style="width: 100%; font-family: Roboto, sans-serif;">
                                Team Reading Orders
                        </button>
                            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>" method="post">
                                <ul id="tag-dropdown" class="dropdown-menu" style="padding: 5px; background-color: #E6F1FE;">
                                <?php foreach ($ro_team_names as $ro_team): ?>
                                    <li style="margin: 5px; width: 305px; font-size: 17px; font-family: Karma, sans-serif;">
                                        <input name = "ro_team_select[]" class = "form-check-input" type= "checkbox" value="<?php echo $ro_team?>"/>
                                        <label class="form-check-label"><?php echo $ro_team?></label>
                                    </li>
                                <?php endforeach; ?>
                                    <br>
                                    <input type="submit" name = "ro_team_submit" value="Select" class = "btn btn-secondary" style="margin: 0 0 0 220px; font-family: Roboto, sans-serif;">
                                </ul>
                            </form> 
                    </div> 
                </div> 
                 <!--CHARACTER RO SELECTOR END-->
                 <!-- EVENT RO SELECTOR START-->
                <div class = "col-3">
                    <div class = "container-fluid">
                        <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" style="width: 100%; font-family: Roboto, sans-serif;">
                                Event Reading Orders
                        </button>
                            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>" method="post">
                                <ul id="tag-dropdown" class="dropdown-menu" style="padding: 5px; background-color: #E6F1FE;">
                                <?php foreach ($ro_event_names as $ro_event): ?>
                                    <li style="margin: 5px; width: 305px; font-size: 17px; font-family: Karma, sans-serif;">
                                        <input name = "ro_event_select[]" class = "form-check-input" type= "checkbox" value="<?php echo $ro_event?>"/>
                                        <label class="form-check-label"><?php echo $ro_event?></label>
                                    </li>
                                <?php endforeach; ?>
                                    <br>
                                    <input type="submit" name = "ro_event_submit" value="Select" class = "btn btn-secondary" style="margin: 0 0 0 220px; font-family: Roboto, sans-serif;">
                                </ul>
                            </form> 
                    </div> 
                </div>
                 <!--EVENT RO SELECTOR END-->
                 <!-- CONTINUITY RO SELECTOR START-->
                <div class = "col-3">
                    <div class = "container-fluid">
                        <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" style="width: 100%; font-family: Roboto, sans-serif;">
                                Continuity Reading Orders
                        </button>
                            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>" method="post">
                                <ul id="tag-dropdown" class="dropdown-menu" style="padding: 5px; background-color: #E6F1FE;">
                                <?php foreach ($ro_continuity_names as $ro_continuity): ?>
                                    <li style="margin: 5px; width: 305px; font-size: 17px; font-family: Karma, sans-serif;">
                                        <input name = "ro_continuity_select[]" class = "form-check-input" type= "checkbox" value="<?php echo $ro_continuity?>"/>
                                        <label class="form-check-label"><?php echo $ro_continuity?></label>
                                    </li>
                                <?php endforeach; ?>
                                    <br>
                                    <input type="submit" name = "ro_continuity_submit" value="Select" class = "btn btn-secondary" style="margin: 0 0 0 220px; font-family: Roboto, sans-serif;">
                                </ul>
                            </form> 
                    </div> 
                </div>
                 <!-- CONTINUITY RO SELECTOR END-->
            </div>
            <br>
            <br>
            <!-- READING ORDERS SELECTED DISPLAY START-->
        
            <div class = "container-fluid" style= "border: black solid 1px;">
                <div class = "row" style="margin: 10px;">
                    <!-- DISPLAY CHARACTER READING ORDERS SELECTED START-->
                    <div class = "col-3">
                        <div class= "container-fluid" style="margin:10px;">
                            <p style= "font-family: Roboto, sans-serif;">Character Reading Orders Selected:</p>
                            <div class= "container-fluid" style="margin:10px; font-family: Karma, sans-serif;">
                                <?php 
                                        if(isset($_POST["ro_char_submit"])){
                                            if(!empty($_POST["ro_char_select"])){
                                                $_SESSION["ro_char_selected"] = $_POST["ro_char_select"];
                                                }
                                        }

                                        if(!empty( $_SESSION["ro_char_selected"] )){
                                            foreach($_SESSION["ro_char_selected"] as $ro_char_selected){
                                                echo $ro_char_selected. "<br>"; }
                                            }
                                    
                                ?>
                            </div>  
                        </div>
                    </div>
                    <!-- DISPLAY CHARACTER READING ORDERS SELECTED END-->
                    <!-- DISPLAY TEAM READING ORDERS SELECTED START-->
                    <div class = "col-3">
                        <div class= "container-fluid" style="margin:10px; font-family: Karma, sans-serif;">
                            <p style= "font-family: Roboto, sans-serif;">Team Reading Orders Selected:</p>
                            <div class= "container-fluid" style="margin:10px;">
                                <?php 
                                
                                        if(isset($_POST["ro_team_submit"])){
                                            if(!empty($_POST["ro_team_select"])){
                                                $_SESSION["ro_team_selected"] = $_POST["ro_team_select"];
                                                
                                                }
                                            }    

                                        if(!empty( $_SESSION["ro_team_selected"] )){
                                            foreach($_SESSION["ro_team_selected"] as $ro_team_selected){
                                                echo $ro_team_selected. "<br>"; }
                                            }    
                                            ?>     
                            </div>
                        </div>
                    </div>
                    <!-- DISPLAY TEAM READING ORDERS SELECTED END-->
                
                    <!-- DISPLAY EVENT READING ORDERS SELECTED START-->
                    <div class = "col-3">
                        <div class= "container-fluid" style="margin:10px; font-family: Karma, sans-serif;">
                            <p style= "font-family: Roboto, sans-serif;">Event Reading Orders Selected:</p>
                            <div class= "container-fluid" style="margin:10px;">
                                <?php 
                                        if(isset($_POST["ro_event_submit"])){
                                            if(!empty($_POST["ro_event_select"])){
                                                $_SESSION["ro_event_selected"] = $_POST["ro_event_select"];
                                                }
                                            }    

                                        if(!empty( $_SESSION["ro_event_selected"] )){
                                            foreach($_SESSION["ro_event_selected"] as $ro_event_selected){
                                                echo $ro_event_selected. "<br>"; }
                                            }    
                                ?>    
                            </div>
                        </div>
                    </div>
                    <!-- DISPLAY EVENT READING ORDERS SELECTED END-->
                    <!-- DISPLAY CONTINUITY READING ORDERS SELECTED START-->
                    <div class = "col-3">
                        <div class= "container-fluid" style="margin:10px; font-family: Karma, sans-serif;">
                            <p style= "font-family: Roboto, sans-serif;">Continuity Reading Orders Selected:</p>
                            <div class= "container-fluid" style="margin:10px;">
                                <?php 
                                        if(isset($_POST["ro_continuity_submit"])){
                                            if(!empty($_POST["ro_continuity_select"])){
                                                $_SESSION["ro_continuity_selected"] = $_POST["ro_continuity_select"];
                                                }
                                            }  

                                        if(!empty( $_SESSION["ro_continuity_selected"] )){
                                            foreach($_SESSION["ro_continuity_selected"] as $ro_continuity_selected){
                                                echo $ro_continuity_selected. "<br>"; }
                                            }    
                                ?>
                            </div>
                        </div>       
                    </div>
                    <!-- DISPLAY CONTINUITY READING ORDERS SELECTED END-->
                </div>
            <!-- READING ORDERS SELECTED DISPLAY END-->
            <!-- SUBMIT READING ORDERS SELECTED START-->
                <div class = "row" style="margin: 10px;">
                    <div class = "col-9"></div>
                    <div class = "col-3">
                        <div class = "container-fluid">
                            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>" method="post">
                                <div class = "container-fluid" style="display:flex;">
                                    <input type="submit" name = "ro_clear" value="Clear" class = "btn btn-secondary" style="  width: 150px; margin: 0 0 0 100px; font-family: Roboto, sans-serif;">
                                    <input type="submit" name = "ro_submit" value="Submit" class = "btn btn-secondary" style=" width: 100px; margin: 0 0 0 50px; font-family: Roboto, sans-serif;"> 

                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        <!-- READING ORDER SELECTOR END-->
        <br>
           <!-- ISSUES COUNT RESULT DISPLAY START-->                           
            <div class = "row">
                <div class = "col-2"></div>
                <div class ="col-3">
                    <h5><u>Showing <?php echo $ro_issues[0]?> out of <?php echo $db_issues[0];?> Issues </u></h5>
                </div>
            </div>
        <!-- ISSUES COUNT RESULT DISPLAY END-->
          <!-- ISSUES DISPLAY START-->
          <!-- ISSUES DISPLAY HEADER START-->
        <br>
            <div class = "row">
                <div class = "col-2">
                    <div class = "row" style = "text-align: center; font-family: Roboto, sans-serif; font-size: 14px;"><h3><b>About</b></h3></div>
                    <div class = "row" style = "margin-left: 10px; text-align: left; font-family: Karma, sans-serif; font-size: 12px;">
                        <p>This database pulls issues from several reading orders and compiles them into a single list.
                        To use it, simply select the reading orders you are interested in from the menu above and hit submit.
                        Character, team, and event reading orders compile the recommended reading for that specific character, team or event. 
                        Continuity reading orders compile the best and most essential comics from each era of DC across the enitre DC Universe.
                        You can then use the tabs at the top of the table to only view issues that have stories that take place in a particular continuity.
                        You can start reading from any continuity section. They are ordered chronologically, so if you only want to cath up with the newest comics start from comics under Infinite Frontier and Beyond.
                        For a more complete reading experience start at Pre-Crisis. 
                        </p>
                    </div>
                </div>
                <div class = "col-10">                        
                    <div class = "container-fluid">
                        <ul class="nav nav-tabs">
                            <li class="nav-item">
                            <?php if ($selected_continuity==""): ?>
                                <a class="nav-link active" aria-current="page" href="?" style= "height: 65px; width: 215px; color: white; font-family: Roboto, sans-serif; background-color: #0476F2; border: solid 1px black;"><b>All</b></a>
                            <?php else: ?>
                                <a class="nav-link" href="?" style= "justify-content: center; height: 65px; width: 215px; font-family: Roboto, sans-serif; color: black; background-color: #4CA1FC; border: solid 1px black;">All</a>
                            <?php endif; ?>
                            </li>
                            <?php foreach ($continuity_names as $continuity): ?>
                            <!-- Changing the color of the tag if it is active, and making it lead back to the unflitered gallery if clicked again -->
                            <?php if ($continuity == $selected_continuity): ?>
                                <li><a class="nav-link active" aria-current="page" href="?" style= "height: 65px; width: 198px; color: white; font-family: Roboto, sans-serif; background-color: #0476F2; border: solid 1px black;"><b><?php echo $continuity?></b></a></li>
                            <!-- if tag is not selected then  clicking the tag just applies the filter to the gallery by adding the tag to the url -->
                            <?php else: ?>
                                <li><a  class="nav-link" href="?continuity=<?php echo urlencode($continuity) ?>" style= "height: 65px; width: 198px; font-family: Roboto, sans-serif; color: black; background-color: #4CA1FC; border: solid 1px black;"><?php echo $continuity?></a></li>
                            <?php endif; ?>
                        <?php endforeach; ?>
                        </ul>
                    </div>
                <!-- ISSUES DISPLAY HEADER END-->
                <!-- ISSUES DISPLAY TABLE START-->
                <div class = "container-fluid" >
                <table class="table table-hover" style="overflow: auto; border-left: 1px solid black; border-right: 1px solid black;">
                        <thead style = " background-color: #4CA1FC; border: 1px solid black;">
                            <tr>
                            <th scope="col">  </th>
                            <th scope="col">Series</th>
                            <th scope="col"> Issue </th>
                            <th scope="col">  </th>
                            <th scope="col">  </th>
                            </tr>
                        </thead>
                        <tbody>
                        <?php 
                        $i = 0; 

                        foreach($issues_info as $issue_info): 
                            $issue_id = $issue_info["id"];
                            $i++;
                            $get_stories_info = "SELECT DISTINCT issue.id, story.id,
                                story.title, continuity.name AS continuity, crossover_event.name AS c_event FROM ((((issue 
                                INNER JOIN has_story ON has_story.issue_id = issue.id) 
                                INNER JOIN story ON has_story.story_id = story.id) 
                                LEFT JOIN continuity ON story.CONTINUITY_id = continuity.id)
                                LEFT JOIN crossover_event ON story.CROSSOVER_EVENT_id = crossover_event.id)
                                WHERE issue.id =".$issue_id."";
                               
                                $stmt8 = $conn->query($get_stories_info);
                                $stories_info = $stmt8->fetchAll(PDO::FETCH_ASSOC); 

                            $get_tags_info = "SELECT issue.id, tag.id AS idtag, tag.name, tag.type FROM ((issue
                            LEFT JOIN has_tag ON issue_id = issue.id)
                            LEFT JOIN tag ON tag_id = tag.id)
                            WHERE issue_id = ".$issue_id."";

                                $stmt7 = $conn->query($get_tags_info);
                                $tags_info = $stmt7->fetchAll(PDO::FETCH_ASSOC); 
                            
            
                                ?>
                            <tr style = "background-color: #E6F1FE">
                            <th style = "font-family: Karma, sans-serif;"scope="row"><?php echo $i;?></th>
                            <td style = "font-family: Karma, sans-serif;"><b><?php echo $issue_info["title"]. " (" .$issue_info["publication_year"]. ")";?></b></td>
                            <td style = "font-family: Karma, sans-serif;"><b><?php echo " # " .$issue_info["number"];?></b></td>
                            <td style="width: 50%">
                                <b>Tagged: </b> 
                                <?php foreach ($tags_info as $key => $tag) {
                                    echo $tag["name"];
                                    if ($key < count($tags_info) - 1) { echo ', '; } 
                                };?>
                            </td>
                            <td>
                                <button style="font-family: Roboto, sans-serif;"class="btn btn-secondary" type="button" data-bs-toggle="collapse" data-bs-target="#<?php echo $i?>" aria-expanded="false" aria-controls="collapseExample">
                                    Expand
                                </button>
                            </td>
                            </tr>
                            <tr>
                            <td colspan = "5">
                            <div class="collapse" id="<?php echo $i?>">
                                <div class="card card-body"  style = "font-family: Karma, sans-serif;">
                                    <div class = "row">
                                        <div class = "col-1">
                                            <h5><b>Series: </b></h5>
                                        </div>
                                        <div class = "col-3">
                                            <p style="font-size: 18px;"> <?php echo $issue_info["title"]. " (" .$issue_info["publication_year"]. ")";?></p>
                                        </div>
                                         <div class = "col-2">
                                            <h5 style="font-size: 16px;"><b>Release Date: </b></h5>
                                        </div>
                                        <div class = "col-2">
                                            <p > <?php echo $issue_info["publication_date"];?></p>
                                        </div>  
                                    </div>
                                    <div class ="row" style= "margin: 0 10px; border-bottom: 1px solid black; ">
                                        <div class="col-2">
                                            <h5 style="font-size: 17px;"><b>Stories</b></h5>
                                        </div>
                                        <div class="col-2">
                                            <h5 style="font-size: 17px;"><b>Characters</b></h5>
                                        </div>
                                        <div class="col-2">
                                            <h5 style="font-size: 17px;"><b>Team</b></h5>
                                        </div>
                                        <div class="col-2">
                                            <h5 style="font-size: 17px;"><b>Continuity</b></h5>
                                        </div>
                                        <div class="col-2">
                                            <h5 style="font-size: 17px;"><b>Event</b></h5>
                                        </div>
                                        <div class="col-2">
                                            <h5 style="font-size: 17px;"><b>Contributors</b></h5>
                                        </div>
                                    </div>
                                    <br>
                                    <?php foreach ($stories_info as $story_info):
                                        $story_id = $story_info["id"];
                                        $get_characters_info = "SELECT dc_character.first_name, dc_character.last_name, mantle.name AS mantle, team.name AS team FROM (((((features
                                        INNER JOIN dc_character ON dc_character_id = dc_character.id)
                                        LEFT JOIN has_mantle ON has_mantle_id = has_mantle.id)
                                        LEFT JOIN mantle ON mantle_id = mantle.id)
                                        LEFT JOIN in_team ON in_team_id = in_team.id)
                                        LEFT JOIN team ON team_id = team.id)
                                        WHERE story_id =".$story_id.""; 

                                        $stmt9 = $conn->query($get_characters_info);
                                        $characters_info = $stmt9->fetchAll(PDO::FETCH_ASSOC);
                                        
                                        $get_contributors_info = "SELECT story_id, person.first_name, person.last_name, role.name AS c_role FROM (((story
                                        INNER JOIN contributed_to ON story.id = story_id)
                                        INNER JOIN person ON person_id = person.id)
                                        INNER JOIN role ON role_id = role.id)
                                        WHERE story.id = ".$story_id."
                                        ORDER BY role.name" ; 
                                             
                                        $stmt10 = $conn->query($get_contributors_info);
                                        $contributors_info = $stmt10->fetchAll(PDO::FETCH_ASSOC);
                                             ?>
                                        
                                        <div class="row" style= "border-bottom: 1px solid black; margin: 10px;">
                                            <div class = "col-2">
                                                <p style= "margin-left: 5px;" ><?php echo $story_info["title"];?> </p>
                                            </div>
                                            <div class = "col-2">
                                                <?php foreach ($characters_info as $character_info): ?>
                                                <div class = "row" style = "height: 55px;">
                                                    <p><?php echo $character_info["first_name"]. " ".$character_info["last_name"];
                                                    if($character_info["mantle"]){
                                                        echo " (As " .$character_info["mantle"]. ")";} 
                                                   
                                                    ?></p>
                                                </div>

                                                <?php endforeach;?>
                                            </div>
                                            <div class="col-2">
                                            <?php foreach ($characters_info as $character_info): ?>
                                                <div class = "row" style = "height: 55px;">
                                                    <p style= "margin-left: 5px;"><?php echo $character_info["team"]?></p>
                                                </div>
                                            <?php endforeach;?>
                                            </div>
                                            <div class="col-2">
                                                <p style= "margin-left: 5px;"><?php echo $story_info["continuity"];?></p>
                                            </div>
                                            <div class="col-2">
                                                <p style= "margin-left: 5px;"><?php echo $story_info["c_event"]?></p>
                                            </div>
                                            <div class = "col-2">
                                                <?php foreach ($contributors_info as $contributor_info): ?>
                                                <div class = "row"s>
                                                    <p><?php echo $contributor_info["first_name"]. " ".$contributor_info["last_name"];
                                                    if($contributor_info["c_role"]){
                                                        echo " (" .$contributor_info["c_role"]. ")";} 
                                                   
                                                    ?></p>
                                                </div>
                                                <?php endforeach;?>
                                            </div> 
                                        </div>
                                    <?php endforeach;?>
                                    <div class ="row">
                                        <div class = "col-2">
                                            <h5><b>Tagged: </b></h5>
                                        </div>
                                        <div class = "col-10">
                                            <?php
                                             foreach ($tags_info as $key => $tag) {
                                                    $tag_id =$tag["idtag"];
                                                    echo "<b>".$tag["name"].": </b>";
                                                    if($tag["type"] == "Character") {
                                                        $get_tag_char_info = "SELECT dc_character_tag.tag_id, dc_character.first_name as Name, dc_character.last_name AS L_Name FROM (((issue
                                                        LEFT JOIN has_tag ON issue_id = issue.id)
                                                        INNER JOIN dc_character_tag ON dc_character_tag_id = dc_character_tag.id)
                                                        INNER JOIN dc_character ON dc_character_id = dc_character.id)
                                                        WHERE issue.id = ".$issue_id."
                                                        AND dc_character_tag.tag_id = ".$tag_id."" ;
                                                        
                                                        $stmt11 = $conn->query($get_tag_char_info);
                                                        $tag_char_info = $stmt11->fetchAll(PDO::FETCH_ASSOC);
                                                       foreach ($tag_char_info as $tag_char) {
                                                        echo " (". $tag_char["Name"]. " " . $tag_char["L_Name"]. ")";}
                                                    };
                                                    if ($tag["type"] == "Team") {
                                                        $get_tag_team_info = "SELECT team_tag.tag_id, team.name FROM (((issue
                                                        LEFT JOIN has_tag ON issue_id = issue.id)
                                                        INNER JOIN team_tag ON team_tag_id = team_tag.id)
                                                        INNER JOIN team ON team_id = team.id)
                                                        WHERE issue.id = ".$issue_id."
                                                        AND team_tag.tag_id = ".$tag_id."" ;

                                                        $stmt12 = $conn->query($get_tag_team_info);
                                                        $tag_team_info = $stmt12->fetchAll(PDO::FETCH_ASSOC);
                                                        foreach ($tag_team_info as $tag_team) {
                                                        echo " (". $tag_team["name"]. ")";}
                                                 
                                                   };

                                                    if ($tag["type"] == "Relationship") {
                                                        $get_tag_relationship_info = "SELECT relationship_tag.tag_id, dc_character.first_name, dc_character.last_name, char_tb.first_name AS name_2, char_tb.last_name AS last_name_2, relationship_type.type FROM ((((((issue
                                                        INNER JOIN has_tag ON issue_id = issue.id)
                                                        INNER JOIN relationship_tag ON relationship_tag_id = relationship_tag.id)
                                                        INNER JOIN relationship ON relationship_id = relationship.id)                                                                                    
                                                        INNER JOIN dc_character ON dc_character_id_1 = dc_character.id)
                                                        LEFT JOIN dc_character AS char_tb ON dc_character_id_2 = char_tb.id)
                                                        INNER JOIN relationship_type ON relationship_type_id = relationship_type.id)
                                                        WHERE issue.id = ".$issue_id."
                                                        AND relationship_tag.tag_id = ".$tag_id."" ;
                                                        
                                                        $stmt13 = $conn->query($get_tag_relationship_info);
                                                        $tag_relationship_info = $stmt13->fetchAll(PDO::FETCH_ASSOC);
                                                        foreach ($tag_relationship_info as $tag_relationship) {
                                                        echo " (" .$tag_relationship["first_name"]. " ".$tag_relationship["last_name"]. " & " .$tag_relationship["name_2"]. " ".$tag_relationship["last_name_2"]. " [" .$tag_relationship["type"]. "] )";}
                                                    }
                                                
                                                     if ($key < count($tags_info) - 1) { echo ', '; } 
                                                  
                                             };
                                            ?>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            </td>
                            </tr>
                        <?php endforeach; ?>
                        <tfoot style= "border: 1px solid black; background-color: #4CA1FC;">
                            <td colspan="5" style= "border: 1px solid black;"></td>
                        </tfoot>
                        </tbody>
                    </table>
                <!-- ISSUES DISPLAY TABLE END-->
            </div>
           
        </div>
        <nav id="header" class= "navbar static-bottom" style = "background-color:#0476F2;"></nav>
         <!-- MAIN BODY END--> 
                              
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
    </body>
</html>