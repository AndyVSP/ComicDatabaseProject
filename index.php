
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

//Intialize variable

$selected_continuity = "";
$selected_continuity = $_GET['continuity'] ?? '';
            
///clear session variables when clear button is pressed//

if(isset($_POST["ro_clear"])){ 
                $_SESSION["ro_continuity_selected"] = "";
                $_SESSION["ro_event_selected"] = "";
                $_SESSION["ro_team_selected"] = "";
                $_SESSION["ro_char_selected"] = "";
            }


//Get list of characters with reading orders
    $get_ro_characters = "SELECT DISTINCT first_name, last_name FROM 
    (dc_character_reading_order INNER JOIN dc_character 
    ON dc_character_id = dc_character.id)";
 
    $stmt = $conn->query($get_ro_characters);
    $ro_character_names = $stmt->fetchAll(PDO::FETCH_ASSOC);

//Get list of teams with reading orders
     $get_ro_teams = "SELECT DISTINCT name FROM 
     (team_reading_order INNER JOIN team 
     ON team_id = team.id)";

    $stmt2 = $conn->query($get_ro_teams);
    $ro_team_names = $stmt2->fetchAll(PDO::FETCH_COLUMN);   

//Get list of events with reading orders
    $get_ro_events = "SELECT DISTINCT name FROM 
    (crossover_event_reading_order INNER JOIN crossover_event
    ON crossover_event_id = crossover_event.id)";

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


//Get list of issues 

            
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
        <link href="/myStyle.css" type="text/css" rel="stylesheet">
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
                                <li style="margin: 5px; width: 270px; font-size: 17px; font-family: Karma, sans-serif;">
                                    <input name = "ro_char_select[]" class = "form-check-input" type= "checkbox" value="<?php echo $ro_character["first_name"]. " ".$ro_character["last_name"]?>"/>
                                    <label class="form-check-label"><?php echo $ro_character["first_name"], " ",$ro_character["last_name"]?></label>
                                </li>
                            <?php endforeach; ?>
                                <br>
                                <input type="submit" name = "ro_char_submit" value="Submit" class = "btn btn-secondary" style="margin: 0 0 0 200px; font-family: Roboto, sans-serif;">
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
                                    <li style="margin: 5px; width: 270px; font-size: 17px; font-family: Karma, sans-serif;">
                                        <input name = "ro_team_select[]" class = "form-check-input" type= "checkbox" value="<?php echo $ro_team?>"/>
                                        <label class="form-check-label"><?php echo $ro_team?></label>
                                    </li>
                                <?php endforeach; ?>
                                    <br>
                                    <input type="submit" name = "ro_team_submit" value="Submit" class = "btn btn-secondary" style="margin: 0 0 0 200px; font-family: Roboto, sans-serif;">
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
                                    <li style="margin: 5px; width: 270px; font-size: 17px; font-family: Karma, sans-serif;">
                                        <input name = "ro_event_select[]" class = "form-check-input" type= "checkbox" value="<?php echo $ro_event?>"/>
                                        <label class="form-check-label"><?php echo $ro_event?></label>
                                    </li>
                                <?php endforeach; ?>
                                    <br>
                                    <input type="submit" name = "ro_event_submit" value="Submit" class = "btn btn-secondary" style="margin: 0 0 0 200px; font-family: Roboto, sans-serif;">
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
                                    <li style="margin: 5px; width: 270px; font-size: 17px; font-family: Karma, sans-serif;">
                                        <input name = "ro_continuity_select[]" class = "form-check-input" type= "checkbox" value="<?php echo $ro_continuity?>"/>
                                        <label class="form-check-label"><?php echo $ro_continuity?></label>
                                    </li>
                                <?php endforeach; ?>
                                    <br>
                                    <input type="submit" name = "ro_continuity_submit" value="Submit" class = "btn btn-secondary" style="margin: 0 0 0 200px; font-family: Roboto, sans-serif;">
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
                                                $_SESSION["ro_char_selected"] = (($_POST["ro_char_select"]));
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
                                                $_SESSION["ro_team_selected"] = (($_POST["ro_team_select"]));
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
                                                $_SESSION["ro_event_selected"] = (($_POST["ro_event_select"]));
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
                                                $_SESSION["ro_continuity_selected"] = (($_POST["ro_continuity_select"]));
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
            <div class = "row"></div>
        <!-- ISSUES COUNT RESULT DISPLAY END-->
          <!-- ISSUES DISPLAY START-->
        <br>
            <div class = "row">
                <div class = "col-2"></div>
                <div class = "col-10">                        
                    <div class = "container-fluid">
                        <ul class="nav nav-tabs">
                            <li class="nav-item">
                            <?php if ($selected_continuity==""): ?>
                                <a class="nav-link active" aria-current="page" href="?" style= "height: 65px; width: 170px; color: white; font-family: Roboto, sans-serif; background-color: #0476F2; border: solid 1px black;">All</a>
                            <?php else: ?>
                                <a class="nav-link" href="?" style= "justify-content: center; height: 65px; width: 170px; font-family: Roboto, sans-serif; color: black; background-color: #4CA1FC; border: solid 1px black;">All</a>
                            <?php endif; ?>
                            </li>
                            <?php foreach ($continuity_names as $continuity): ?>
                            <!-- Changing the color of the tag if it is active, and making it lead back to the unflitered gallery if clicked again -->
                            <?php if ($continuity == $selected_continuity): ?>
                                <li><a class="nav-link active" aria-current="page" href="?" style= "height: 65px; width: 180px; color: white; font-family: Roboto, sans-serif; background-color: #0476F2; border: solid 1px black;"><?php echo $continuity?></a></li>
                            <!-- if tag is not selected then  clicking the tag just applies the filter to the gallery by adding the tag to the url -->
                            <?php else: ?>
                                <li><a  class="nav-link" href="?continuity=<?php echo urlencode($continuity) ?>" style= "height: 65px; width: 180px; font-family: Roboto, sans-serif; color: black; background-color: #4CA1FC; border: solid 1px black;"><?php echo $continuity?></a></li>
                            <?php endif; ?>
                        <?php endforeach; ?>
                
                </div>
            </div>
        </div>
         <!-- MAIN BODY END-->                               
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
    </body>
</html>