<!DOCTYPE html>
<html>
	<head>
		<title>W3.CSS Template</title>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
		<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Roboto'>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
		<style>
		html,body,h1,h2,h3,h4,h5,h6 {font-family: "Roboto", sans-serif}
		table {
			border-collapse: collapse;
			border-spacing: 0;
			width: 90%;
			border: 1px solid #ddd;
		}

		th, td {
			text-align: left;
			padding: 16px;
		}

		tr:nth-child(even) {
			background-color: #f2f2f2;
		}
		</style>
	</head>
	<body>
		
		
		<!-- Use this section to connect to your database. -->
		<?php 
			$con = mysqli_connect("localhost","root","", "sakila");
			
			if (mysqli_connect_errno()) {
				echo "Failed to connect to MySQL: " . mysqli_connect_error();
				exit();
			}
		?>		
		
		<!-- Header section -->
		<div class="w3-container w3-blue-grey">
			<h1>INFS 657: Database design &amp management</h1>
		</div>
		
		<div style="width: 96%; margin:auto;">
		<!-- Left column section -->
		<div class="w3-third" style="height: 1500px;">
			<h2>Sakila database overview</h2>
			<p>Sakila is a database of fictional films. They were procedurally created, so the titles are pretty wacky.</p>
			<div>
				<?php
					if ($result = mysqli_query($con, "select count(actor_id) from actor")) {
						$actor_count = mysqli_fetch_array($result);
						mysqli_free_result($result);
						echo "Actor count is: " . $actor_count['count(actor_id)'] . "!";
					}
				?>
			</div>
		</div>
		
		
		<!-- Right column section -->
		<div class="w3-two-third">
			<h2>What films are available?</h2>	
			<p>Filter your search based on some choices: </p>
			
			<!-- Get input from the user to filter results -->
			<form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>" method="post">
				<label for="genre">Genre:</label>
				<select name="genre" id ="genre">
					<?php 
						if ($result = mysqli_query($con, "select name from category")) {
							while ($field = mysqli_fetch_array($result)) {
								echo '<option value="' . $field['name'] . '">' . $field['name'] . '</option·>';
							}
						}
					?>
				</select>
				<label for="descript">Description:</label>
				<input type="text" id="descript" name="descript_name" value=""></input>
				<input type="submit" name="submit" value="Submit">
			</form>
			</br>
			
			<div style="height: 500px; overflow:auto;">
			<?php
				$query = "";
				if (isset($_POST['descript_name'])) {
					$query = 'select title, description, release_year ' . 
						'from film, film_category, category ' . 
						'where film.film_id= film_category.film_id ' . 
						'and film_category.category_id = category.category_id ' . 
						'and category.name = "' . $_POST['genre'] . '" ' .
						'and film.description like "%' . $_POST['descript_name'] . '%"';
				}
				else {
					$query = "select title, description, release_year from film";
				}
				
				if ($result = mysqli_query($con, $query)) {
					echo '<table><tr><th>Name</th><th>Description</th><th>Release year</th></tr>';
					while($row = mysqli_fetch_array($result)){
						$name = $row['title'];
						$description = $row['description'];
						$year = $row['release_year'];
						
						echo '<tr><td>' . $name . '</td><td>' . $description . '</td><td>' . $year . '</td></tr>';
					}
					echo '</table>';
					
					// Free result set
					mysqli_free_result($result);
				}
			?>
			</div>
			<!-- Add a new table here -->
			<div>
			<p>Replace this paragraph with your table. Start with a query in MySQL if you need inspiration.</p>
			</div>
		</div>
		</div>
	</body>
</html>