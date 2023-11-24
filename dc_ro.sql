/* Create database */
CREATE DATABASE dc_ro;

USE dc_ro;

/* Create tables */
CREATE TABLE Series(
    id INT NOT NULL AUTO_INCREMENT, 
    title varchar(500) NOT NULL,
    publication_year year NOT NULL,
    description varchar(8000),
    PRIMARY KEY(id)
);

CREATE TABLE Issue(
    id int NOT NULL AUTO_INCREMENT,
    SERIES_id int NOT NULL, 
    number varchar(8000),
    publication_date date NOT NULL,
    cover_date date NOT NULL,
    is_anthology tinyint(1) NOT NULL,
    has_backup tinyint(1) NOT NULL,
    description text,
    PRIMARY KEY(id),
    FOREIGN KEY(series_id) REFERENCES Series(id)
);
CREATE TABLE Continuity(
    id int NOT NULL AUTO_INCREMENT,
    name varchar(500) NOT NULL,
    description varchar(8000),
    PRIMARY KEY(id)
);

CREATE TABLE Crossover_Event(
    id int NOT NULL AUTO_INCREMENT,
    name varchar(500) NOT NULL,
    description varchar(8000),
    PRIMARY KEY(id)
);
CREATE TABLE Story(
    id int NOT NULL AUTO_INCREMENT,
    title varchar(500),
    CONTINUITY_id int NOT NULL,
    CROSSOVER_EVENT_id int,
    PRIMARY KEY(id),
    FOREIGN KEY(CONTINUITY_id) REFERENCES Continuity(id),
    FOREIGN KEY(CROSSOVER_EVENT_id) REFERENCES Crossover_Event(id)
);

CREATE TABLE Has_Story(
    ISSUE_id int NOT NULL,
    STORY_id int NOT NULL,
    PRIMARY KEY(ISSUE_id, STORY_id),
    FOREIGN KEY(ISSUE_id) REFERENCES Issue(id),
    FOREIGN KEY(STORY_id) REFERENCES Story(id)
);

CREATE TABLE Person(
    id int NOT NULL AUTO_INCREMENT,
    first_name varchar(500) NOT NULL,
    last_name varchar(500),
    PRIMARY KEY(id)
);

CREATE TABLE Role(
    id int NOT NULL AUTO_INCREMENT,
    name varchar(500) NOT NULL,
    description varchar(8000),
    PRIMARY KEY(id)
);

CREATE TABLE Contributed_To(
    id int NOT NULL AUTO_INCREMENT,
    ROLE_id int NOT NULL,
    PERSON_id int NOT NULL,
    STORY_id int NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(ROLE_id) REFERENCES Role(id),
    FOREIGN KEY(PERSON_id) REFERENCES Person(id),
    FOREIGN KEY(STORY_id) REFERENCES Story(id)
);

CREATE TABLE Tag(
    id int NOT NULL AUTO_INCREMENT,
    name varchar(500) NOT NULL,
    description varchar(8000),
    type varchar(500),
    PRIMARY KEY(id)
);

CREATE TABLE DC_Character(
    id int NOT NULL AUTO_INCREMENT,
    first_name varchar(500) NOT NULL,
    last_name varchar(500),
    description text,
    PRIMARY KEY(id)
);

CREATE TABLE Alias(
    id int NOT NULL AUTO_INCREMENT,
    name varchar(500) NOT NULL,
    DC_CHARACTER_id int,
    notes varchar(8000),
    PRIMARY KEY(id),
    FOREIGN KEY(DC_CHARACTER_id) REFERENCES DC_Character(id)
);

CREATE TABLE Mantle(
    id int NOT NULL AUTO_INCREMENT,
    name varchar(500) NOT NULL,
    description varchar(8000),
    PRIMARY KEY(id)
);

CREATE TABLE Has_Mantle(
    id int NOT NULL AUTO_INCREMENT,
    MANTLE_id int NOT NULL,
    DC_CHARACTER_id int NOT NULL,
    note varchar(8000),
    current tinyint(1) NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(MANTLE_id) REFERENCES Mantle(id),
    FOREIGN KEY(DC_CHARACTER_id) REFERENCES DC_Character(id)
);

CREATE TABLE Team(
    id int NOT NULL AUTO_INCREMENT,
    name varchar(500) NOT NULL,
    description text,
    PRIMARY KEY(id)
);

CREATE TABLE In_Team(
    id int NOT NULL AUTO_INCREMENT,
    TEAM_id int NOT NULL,
    DC_CHARACTER_id int NOT NULL,
    note varchar(8000),
    current tinyint(1) NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(TEAM_id) REFERENCES Team(id),
    FOREIGN KEY(DC_CHARACTER_id) REFERENCES DC_Character(id)
);

CREATE TABLE Relationship_Type(
    id int NOT NULL AUTO_INCREMENT,
    type varchar(500) NOT NULL,
    description varchar(8000),
    PRIMARY KEY(id)
);

CREATE TABLE Relationship(
    id int NOT NULL AUTO_INCREMENT,
    DC_CHARACTER_id_1 int NOT NULL,
    DC_CHARACTER_id_2 int NOT NULL,
    RELATIONSHIP_TYPE_id int NOT NULL,
    current tinyint(1) NOT NULL,
    note varchar(8000),
    PRIMARY KEY(id),
    FOREIGN KEY(DC_CHARACTER_id_1) REFERENCES DC_Character(id),
    FOREIGN KEY(DC_CHARACTER_id_2) REFERENCES DC_Character(id),
    FOREIGN KEY(RELATIONSHIP_TYPE_id) REFERENCES Relationship_Type(id)
);

CREATE TABLE DC_Character_Tag(
    id int NOT NULL AUTO_INCREMENT,
    TAG_id int NOT NULL,
    DC_CHARACTER_id int NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(TAG_id) REFERENCES Tag(id),
    FOREIGN KEY(DC_CHARACTER_id) REFERENCES DC_Character(id)
);

CREATE TABLE Team_Tag(
    id int NOT NULL AUTO_INCREMENT,
    TAG_id int NOT NULL,
    TEAM_id int NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(TAG_id) REFERENCES Tag(id),
    FOREIGN KEY(TEAM_id) REFERENCES Team(id)
);

CREATE TABLE Relationship_Tag(

    TAG_id int NOT NULL,
    id int NOT NULL AUTO_INCREMENT,
    RELATIONSHIP_id int NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(TAG_id) REFERENCES Tag(id),
    FOREIGN KEY(RELATIONSHIP_id) REFERENCES Relationship(id)
);


CREATE TABLE Features(
    id int NOT NULL AUTO_INCREMENT,
    STORY_id int NOT NULL,
    DC_CHARACTER_id int NOT NULL,
    HAS_MANTLE_id int,
    IN_TEAM_id int,
    PRIMARY KEY(id),
    FOREIGN KEY(STORY_id) REFERENCES Story(id),
    FOREIGN KEY(DC_CHARACTER_id) REFERENCES DC_Character(id),
    FOREIGN KEY(HAS_MANTLE_id) REFERENCES Has_Mantle(id),
    FOREIGN KEY(IN_TEAM_id) REFERENCES In_Team(id)
);

CREATE TABLE Has_Tag(
    id int NOT NULL AUTO_INCREMENT,
    ISSUE_id int NOT NULL,
    TAG_id int,
    DC_CHARACTER_TAG_id int,
    TEAM_TAG_id int,
    Relationship_Tag_id int,
    note varchar(8000),
    PRIMARY KEY(id),
    FOREIGN KEY(ISSUE_id) REFERENCES Issue(id),
    FOREIGN KEY(TAG_id) REFERENCES Tag(id),
    FOREIGN KEY(DC_Character_Tag_id) REFERENCES DC_Character_Tag(id),
    FOREIGN KEY(Team_Tag_id) REFERENCES Team_Tag(id),
    FOREIGN KEY(Relationship_Tag_id) REFERENCES Relationship_Tag(id)
);

CREATE TABLE Source(
    id int NOT NULL AUTO_INCREMENT,
    name varchar(500),
    description text,
    link varchar(500),
    PRIMARY KEY(id)
);

CREATE TABLE Reading_Order(
    id int NOT NULL AUTO_INCREMENT,
    SOURCE_id int NOT NULL,
    name varchar(500),
    type varchar(500) NOT NULL,
    link varchar(500),
    PRIMARY KEY(id),
    FOREIGN KEY(SOURCE_id) REFERENCES Source(id)
);

CREATE TABLE DC_Character_Reading_Order(
    READING_ORDER_id int NOT NULL,
    DC_CHARACTER_id int NOT NULL,
    PRIMARY KEY(READING_ORDER_id),
    FOREIGN KEY(READING_ORDER_id) REFERENCES Reading_Order(id),
    FOREIGN KEY(DC_CHARACTER_id) REFERENCES DC_Character(id)
);

CREATE TABLE Continuity_Reading_Order(
    READING_ORDER_id int NOT NULL,
    CONTINUITY_id int NOT NULL,
    PRIMARY KEY(READING_ORDER_id),
    FOREIGN KEY(READING_ORDER_id) REFERENCES Reading_Order(id),
    FOREIGN KEY(CONTINUITY_id) REFERENCES Continuity(id)
);

CREATE TABLE Crossover_Event_Reading_Order(
    READING_ORDER_id int NOT NULL,
    CROSSOVER_EVENT_id int NOT NULL,
    PRIMARY KEY(READING_ORDER_id),
    FOREIGN KEY(READING_ORDER_id) REFERENCES Reading_Order(id),
    FOREIGN KEY(CROSSOVER_EVENT_id) REFERENCES Crossover_Event(id)
);

CREATE TABLE Team_Reading_Order(
    READING_ORDER_id int NOT NULL,
    TEAM_id int NOT NULL,
    PRIMARY KEY(READING_ORDER_id),
    FOREIGN KEY(READING_ORDER_id) REFERENCES Reading_Order(id),
    FOREIGN KEY(TEAM_id) REFERENCES Team(id)
);

CREATE TABLE In_Reading_Order(
    id int NOT NULL AUTO_INCREMENT,
    READING_ORDER_id int NOT NULL,
    ISSUE_id int NOT NULL,
    position int NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(READING_ORDER_id) REFERENCES Reading_Order(id),
    FOREIGN KEY(ISSUE_id) REFERENCES Issue(id)
);

/* Finished tables */

/* Insert Data */

/*SERIES TABLE DATA */
INSERT INTO Series(title, publication_year, description)
VALUES
    ("Detective Comics", "1937", 
    "Bruce Wayne has trained his body beyond the peak human perfection; he's trained his mind to focus on minute details to deter criminal enterprises. As the Batman, he's a symbol of terror, striking at the hearts of criminals and villains across the globe."),
    ("The New Teen Titans", "1984", 
    "The New Teen Titans is a comic book series by DC Comics."),
    ("Batman Eternal", "2014", "Batman Eternal is a comic book series by DC Comics."),
    ("Young Justice", "2019", 
    "Superboy! Wonder Girl! Robin! Impulse! Amethyst! WONDER COMICS introduces a brand-new series that also brings in new heroes Teen Lantern and Jinny Hex! This mix of fan favorites and new legacy heroes will be the center point for some of the biggest ongoings at DC! As if that werent enough, BRIAN MICHAEL BENDIS reunites with all-star artist PATRICK GLEASON to bring the new heroes to life!"),
    ("Steelworks", "2023", "Just in time for his 30th anniversary, John Henry Irons must bring Metropolis into the future while trusting his niece Natasha to carry the mantle of Steel.");

/*ISSUE TABLE DATA */
INSERT INTO Issue(SERIES_id, number, publication_date, cover_date, is_anthology, has_backup, description)
VALUES
    ((SELECT id FROM Series WHERE title = "Detective Comics" AND publication_year = "1937"),
    "27", "1939-03-30", "1939-05-00", 1, 0, "The very first appearance of the Bat-Man in the six-page story The Case of the Criminal Syndicate!. This issue also features the first appearances of Commissioner Gordon and the revelation of the Bat-Man's secret identity as Bruce Wayne."),
    ((SELECT id FROM Series WHERE title = "The New Teen Titans" AND publication_year = "1984"),
    "16", "1986-01-01", "1986-00-00", 0, 0, 
    "What could have possibly happened to set the Titans against the alien freedom fighters known as the Omega Men? Could it be the fact that Starfire is being subjected to a prearranged marriage?"),
    ((SELECT id FROM Series WHERE title = "Batman Eternal" AND publication_year = "2014"),
    "3", "2014-04-23", "2014-06-00", 0, 0,
    "A gang war erupts in Gotham City, but the G.C.P.D. doesn't plan to help Batman stop it. Plus: The return of a fan-favorite Batman supporting character: Stephanie Brown!"),
    ((SELECT id FROM Series WHERE title = "Young Justice" AND publication_year = "2019"),
    "1", "2019-01-09", "2019-03-00", 0, 0,
    "Superboy! Wonder Girl! Robin! Impulse! Amethyst! Theyre all united in YOUNG JUSTICE #1, the debut issue of a brand-new series that also introduces new heroes Teen Lantern and Jinny Hex! When the nightmare dimension known as Gemworld invades Metropolis, these teen heroes reunite to deal with the situation—but theyre shocked to discover the battle may be the key to the return of Conner Kent, a.k.a. Superboy!"),
    ((SELECT id FROM Series WHERE title = "Steelworks" AND publication_year = "2023"),
    "1", "2023-06-06", "2023-08-00", 0, 0,
    "FORGING THE FUTURE! The Metropolis of the future is here today, but can it survive a terrorist whos out for revenge against its builder—John Henry Irons, a.k.a. Steel—and his company, Steelworks…and who possesses secrets that could undo everything John has worked so hard to build?
    While Johns professional life is firing on all cylinders, his personal life is even better, as his on-again, off-again relationship with Lana Lang might be back on, permanently. Now he must decide whether its time to give up being Steel once and for all. 
    But does John even know who he would be without his superhero identity? 
    How does the other Steel—Johns niece, Natasha Irons—feel about his momentous decision? And does any of that matter if Steelworks crumbles around him when he lacks the superpowers to fight back? 
    Writer Michael Dorn (the voice of Steel in Superman: The Animated Series) teams up with artist Sami Basri (Harley Quinn, Catwoman) to bring you the next chapter of Steels saga in this not-to-be missed six-issue miniseries!");

/*CONTINUITY TABLE DATA */
INSERT INTO Continuity(name, description)
VALUES
    ("Pre-Crisis", "Before Crisis on Infinite Earths"),
    ("Post-Crisis", "After Crisis on Infinite Earths, before Flashpoint"),
    ("New 52", "After Flashpoint, before Rebirth. The New 52 was a full reboot completely rewriting character histories"),
    ("Rebirth", "After New 52, Before Infinte Frontier. Rebirth keeps the New 52 canon but gives characters access to some of their Post-Crisis memories"),
    ("Infinite Frontier and Beyond", "After Rebirth. Infinite Frontier makes Post-Crisis stories canon in main continuity while keeping some elements of New 52 and Rebirth, and the after the Dawn of DC relaunch also added Pre-Crisis continuity into current canon");
   

/*CROSSOVER_EVENT TABLE DATA */
INSERT INTO Crossover_Event(name, description)
VALUES
    ("Crisis on Infinite Earths", 
    "Crisis on Infinite Earths in 1985 was company wide crossover event. This was a multiversal catastrophe which destroyed multiple parallel universes and recreated the main universe."),
    ("Flashpoint", ""),
    ("Dark Nights: Death Metal", ""),
    ("Dark Crisis", "");


/*STORY TABLE DATA */

INSERT INTO Story(title, CONTINUITY_id, CROSSOVER_EVENT_id)
VALUES
    ("The Case of the Chemical Syndicate",
    (SELECT id FROM Continuity WHERE name = "Pre-Crisis"),
    ""),
    ("The Killers of Kurdistan",
    (SELECT id FROM Continuity WHERE name = "Pre-Crisis"),
    ""),
    ("Murder on the Oceanic Line Docks",
    (SELECT id FROM Continuity WHERE name = "Pre-Crisis"),
    ""),
    ("The Murderer on Vacation",
    (SELECT id FROM Continuity WHERE name = "Pre-Crisis"),
    ""),
    ("The Night Before",
    (SELECT id FROM Continuity WHERE name = "Post-Crisis"), 
    ""),
    ("Batman Eternal #3", 
    (SELECT id FROM Continuity WHERE name = "New 52"),
    ""),
    ("Seven Crises, Part 1",
    (SELECT id FROM Continuity WHERE name = "Rebirth"),
    ""),
    ("Chapter 1: City of Tomorrow",
    (SELECT id FROM Continuity WHERE name = "Infinite Frontier and Beyond"),
    "");

/*HAS_STORY TABLE DATA */
INSERT INTO Has_Story
VALUES
    ((SELECT Issue.id FROM (Issue INNER JOIN Series ON SERIES_id = Series.id)
     WHERE title = "Detective Comics" AND publication_year = "1937"
     AND number ="27"), 
     (SELECT Story.id FROM Story WHERE title = "The Case of the Chemical Syndicate")),
    ((SELECT Issue.id FROM (Issue INNER JOIN Series ON SERIES_id = Series.id)
     WHERE title = "Detective Comics" AND publication_year = "1937"
     AND number ="27"), 
     (SELECT id FROM Story WHERE title = "The Killers of Kurdistan")),
    ((SELECT Issue.id FROM (Issue INNER JOIN Series ON SERIES_id = Series.id) 
     WHERE title = "Detective Comics" AND publication_year = "1937"
     AND number ="27"), 
     (SELECT id FROM Story WHERE title = "Murder on the Oceanic Line Docks")),
    ((SELECT Issue.id FROM (Issue INNER JOIN Series ON SERIES_id = Series.id)
     WHERE title = "Detective Comics" AND publication_year = "1937"
     AND number ="27"), 
     (SELECT id FROM Story WHERE title = "The Murderer on Vacation")),
    ((SELECT Issue.id FROM (Issue INNER JOIN Series ON SERIES_id = Series.id)
     WHERE title = "The New Teen Titans" AND publication_year = "1984"
     AND number ="16"), 
     (SELECT id FROM Story WHERE title = "The Night Before")),
    ((SELECT Issue.id FROM (Issue INNER JOIN Series ON SERIES_id = Series.id)
     WHERE title = "Batman Eternal" AND publication_year = "2014"
     AND number ="3"), 
     (SELECT id FROM Story WHERE title = "Batman Eternal #3")),
    ((SELECT Issue.id FROM (Issue INNER JOIN Series ON SERIES_id = Series.id)
     WHERE title = "Young Justice" AND publication_year = "2019"
     AND number ="1"), 
     (SELECT id FROM Story WHERE title = "Seven Crises, Part 1")),
    ((SELECT Issue.id FROM (Issue INNER JOIN Series ON SERIES_id = Series.id)
     WHERE title = "Steelworks" AND publication_year = "2023"
     AND number ="1"), 
     (SELECT id FROM Story WHERE title = "Chapter 1: City of Tomorrow"));   

/*PERSON TABLE DATA */

INSERT INTO Person(first_name, last_name)
VALUES
    ("Bill", "Finger"),
    ("Bob", "Kane"),
    ("Vin", "Sullivan"),
    ("Gardner", "Fox"),
    ("Fred", "Guardineer"),
    ("Jim", "Chambers"),
    ("Jerry", "Siegel"),
    ("Joe", "Shuster"),
    ("Marv", "Wolfman"),
    ("Eduardo", "Barreto"),
    ("Romeo", "Tanghal"),
    ("Chuck", "Patton"),
    ("Adrianne", "Roy"),
    ("Bob", "Lappan"),
    ("Scott", "Snyder"),
    ("James", "Tynion IV"),
    ("Jason", "Fabok"),
    ("Taylor", "Esposito"),
    ("Katie", "Kubert"),
    ("Jenette", "Kahn"),
    ("Brian Michael", "Bendis"),
    ("Patrick", "Gleason"),
    ("Alejandro", "Sanchez"),
    ("Mike", "Cotton"),
    ("Andy", "Khouri"),
    ("Bob", "Harras"),
    ("Michael", "Dorn"),
    ("Sami", "Basri"),
    ("Andrew", "Dalhouse"),
    ("Rob", "Leigh"),
    ("Paul", "Kaminski"),
    ("Marie", "Javins");


/*ROLE TABLE DATA */

INSERT INTO Role(name, description)
VALUES  
    ("Writer", "Person who wrote the comic script or plot"),
    ("Artist", "Person who created the art in the comic. 
    Includes: Inkers, Pencilers, and Colorists"),
    ("Letterer", "Person who did the lettering for the comic"),
    ("Editor", "The person who edited the comic"),
    ("Editor in Chief", "The head editor in charge of the comic");

/*FULL TABLE DATA */

INSERT INTO Contributed_To(ROLE_id, PERSON_id, STORY_id)
VALUES
    ((SELECT id FROM Role WHERE name = "Writer"),
     (SELECT id FROM Person WHERE first_name = "Bill"
     AND last_name = "Finger"), 
     (SELECT id FROM Story WHERE title = "The Case of the Chemical Syndicate")),
    ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Bob"
     AND last_name = "Kane"), 
     (SELECT id FROM Story WHERE title = "The Case of the Chemical Syndicate")), 
    ((SELECT id FROM Role WHERE name = "Letterer"),
     (SELECT id FROM Person WHERE first_name = "Bob"
     AND last_name = "Kane"), 
     (SELECT id FROM Story WHERE title = "The Case of the Chemical Syndicate")), 
    ((SELECT id FROM Role WHERE name = "Editor"),
     (SELECT id FROM Person WHERE first_name = "Vin"
     AND last_name = "Sullivan"), 
     (SELECT id FROM Story WHERE title = "The Case of the Chemical Syndicate")), 
    ((SELECT id FROM Role WHERE name = "Editor"),
     (SELECT id FROM Person WHERE first_name = "Vin"
     AND last_name = "Sullivan"), 
     (SELECT id FROM Story WHERE title = "The Killers of Kurdistan")), 
    ((SELECT id FROM Role WHERE name = "Editor"),
     (SELECT id FROM Person WHERE first_name = "Vin"
     AND last_name = "Sullivan"), 
     (SELECT id FROM Story WHERE title = "Murder on the Oceanic Line Docks")), 
    ((SELECT id FROM Role WHERE name = "Editor"),
     (SELECT id FROM Person WHERE first_name = "Vin"
     AND last_name = "Sullivan"), 
     (SELECT id FROM Story WHERE title = "The Murderer on Vacation")),
    ((SELECT id FROM Role WHERE name = "Writer"),
     (SELECT id FROM Person WHERE first_name = "Gardner"
     AND last_name = "Fox"), 
     (SELECT id FROM Story WHERE title = "The Killers of Kurdistan")), 
    ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Fred"
     AND last_name = "Guardineer"), 
     (SELECT id FROM Story WHERE title = "The Killers of Kurdistan")), 
    ((SELECT id FROM Role WHERE name = "Letterer"),
     (SELECT id FROM Person WHERE first_name = "Fred"
     AND last_name = "Guardineer"), 
     (SELECT id FROM Story WHERE title = "The Killers of Kurdistan")), 
    ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Jim"
     AND last_name = "Chambers"), 
     (SELECT id FROM Story WHERE title = "Murder on the Oceanic Line Docks")), 
    ((SELECT id FROM Role WHERE name = "Writer"),
     (SELECT id FROM Person WHERE first_name = "Jerry"
     AND last_name = "Siegel"), 
     (SELECT id FROM Story WHERE title = "The Murderer on Vacation")),
    ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Joe"
     AND last_name = "Shuster"), 
     (SELECT id FROM Story WHERE title = "The Murderer on Vacation")),
    ((SELECT id FROM Role WHERE name = "Writer"),
     (SELECT id FROM Person WHERE first_name = "Marv"
     AND last_name = "Wolfman"), 
     (SELECT id FROM Story WHERE title = "The Night Before")),
    ((SELECT id FROM Role WHERE name = "Editor"),
     (SELECT id FROM Person WHERE first_name = "Marv"
     AND last_name = "Wolfman"), 
     (SELECT id FROM Story WHERE title = "The Night Before")),
    ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Eduardo"
     AND last_name = "Barreto"), 
     (SELECT id FROM Story WHERE title = "The Night Before")),
    ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Romeo"
     AND last_name = "Tanghal"), 
     (SELECT id FROM Story WHERE title = "The Night Before")),
    ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Chuck"
     AND last_name = "Patton"), 
     (SELECT id FROM Story WHERE title = "The Night Before")),
    ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Adrianne"
     AND last_name = "Roy"), 
     (SELECT id FROM Story WHERE title = "The Night Before")),
    ((SELECT id FROM Role WHERE name = "Letterer"),
     (SELECT id FROM Person WHERE first_name = "Bob"
     AND last_name = "Lappan"), 
     (SELECT id FROM Story WHERE title = "The Night Before")),
    ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Romeo"
     AND last_name = "Tanghal"), 
     (SELECT id FROM Story WHERE title = "The Night Before")),
    ((SELECT id FROM Role WHERE name = "Writer"),
     (SELECT id FROM Person WHERE first_name = "Scott"
     AND last_name = "Snyder"), 
     (SELECT id FROM Story WHERE title = "Batman Eternal #3")),
    ((SELECT id FROM Role WHERE name = "Writer"),
     (SELECT id FROM Person WHERE first_name = "Scott"
     AND last_name = "Snyder"), 
     (SELECT id FROM Story WHERE title = "Batman Eternal #3")),
     ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Jason"
     AND last_name = "Fabok"), 
     (SELECT id FROM Story WHERE title = "Batman Eternal #3")),
     ((SELECT id FROM Role WHERE name = "Letterer"),
     (SELECT id FROM Person WHERE first_name = "Taylor"
     AND last_name = "Esposito"), 
     (SELECT id FROM Story WHERE title = "Batman Eternal #3")),
      ((SELECT id FROM Role WHERE name = "Editor"),
     (SELECT id FROM Person WHERE first_name = "Katie"
     AND last_name = "Kubert"), 
     (SELECT id FROM Story WHERE title = "Batman Eternal #3")),
      ((SELECT id FROM Role WHERE name = "Editor in Chief"),
     (SELECT id FROM Person WHERE first_name = "Jenette"
     AND last_name = "Kahn"), 
     (SELECT id FROM Story WHERE title = "Batman Eternal #3")),
    ((SELECT id FROM Role WHERE name = "Writer"),
     (SELECT id FROM Person WHERE first_name = "Brian Michael"
     AND last_name = "Bendis"), 
     (SELECT id FROM Story WHERE title = "Seven Crises, Part 1")),
    ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Patrick"
     AND last_name = "Gleason"), 
     (SELECT id FROM Story WHERE title = "Seven Crises, Part 1")),
    ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Alejandro"
     AND last_name = "Sanchez"), 
     (SELECT id FROM Story WHERE title = "Seven Crises, Part 1")),
    ((SELECT id FROM Role WHERE name = "Editor"),
     (SELECT id FROM Person WHERE first_name = "Mike"
     AND last_name = "Cotton"), 
     (SELECT id FROM Story WHERE title = "Seven Crises, Part 1")),
    ((SELECT id FROM Role WHERE name = "Editor"),
     (SELECT id FROM Person WHERE first_name = "Andy"
     AND last_name = "Khouri"), 
     (SELECT id FROM Story WHERE title = "Seven Crises, Part 1")),
    ((SELECT id FROM Role WHERE name = "Editor in Chief"),
     (SELECT id FROM Person WHERE first_name = "Bob"
     AND last_name = "Harras"), 
     (SELECT id FROM Story WHERE title = "Seven Crises, Part 1")),
    ((SELECT id FROM Role WHERE name = "Writer"),
     (SELECT id FROM Person WHERE first_name = "Michael"
     AND last_name = "Dorn"), 
     (SELECT id FROM Story WHERE title = "Chapter 1: City of Tomorrow")),
     ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Sami"
     AND last_name = "Basri"), 
     (SELECT id FROM Story WHERE title = "Chapter 1: City of Tomorrow")),
     ((SELECT id FROM Role WHERE name = "Artist"),
     (SELECT id FROM Person WHERE first_name = "Andrew"
     AND last_name = "Dalhouse"), 
     (SELECT id FROM Story WHERE title = "Chapter 1: City of Tomorrow")),
     ((SELECT id FROM Role WHERE name = "Letterer"),
     (SELECT id FROM Person WHERE first_name = "Rob"
     AND last_name = "Leigh"), 
     (SELECT id FROM Story WHERE title = "Chapter 1: City of Tomorrow")),
     ((SELECT id FROM Role WHERE name = "Editor"),
     (SELECT id FROM Person WHERE first_name = "Paul"
     AND last_name = "Kaminski"), 
     (SELECT id FROM Story WHERE title = "Chapter 1: City of Tomorrow")),
     ((SELECT id FROM Role WHERE name = "Editor in Chief"),
     (SELECT id FROM Person WHERE first_name = "Marie"
     AND last_name = "Javins"), 
     (SELECT id FROM Story WHERE title = "Chapter 1: City of Tomorrow"));

/*TAG TABLE DATA */
INSERT INTO Tag(name, description, type)
VALUES 
    ("First Appearance", "Marks the first time a character appears in a canon comic", "Character"),
    ("Reintroduction", "Marks the first time this character appears after a continuity reboot", "Character"),
    ("Team Event", "Marks a significant event for the team", "Team"),
    ("Relationship Event", "Marks a significant event for this relationship", "Relationship");
    
/*DC_CHARACTER TABLE DATA */
INSERT INTO DC_Character(first_name, last_name, description)
VALUES
    ("Bruce", "Wayne", 
    "Batman was a vigilante and the superhero protector of Gotham City, a man dressed like a bat who fights against evil and strikes terror into the hearts of criminals everywhere. In his secret identity, he was Bruce Wayne, a billionaire industrialist and notorious playboy."),
    ("Dick", "Grayson", 
    "Dick Grayson was the adopted son of Bruce Wayne, the first Robin, Nightwing, and a featured member of the Batfamily."),
    ("Koriand'r", "",
    "Starfire, former royalty of Tamaran, was a recurring member of the Teen Titans."),
    ("Joey", "Wilson", 
    "Joseph Wilson was the son of Slade Wilson, from whom he inherited the metahuman gene, and Adeline Kane. He became mute in childhood, when one of his father's enemies cut his throat."),
    ("Tim", "Drake", 
    "Timothy Jackson Drake-Wayne was the third Robin and a prominent member of the Batfamily."),
    ("Stephanie", "Brown", 
    "Stephanie Brown was a prominent member of the Batfamily, the fourth Robin and was known to many as Spoiler. She also took over the Batgirl mantle after the events of Battle for the Cowl."),
    ("Kon", "El", 
    "Kon-El was the clone of Superman and a recurring member of Young Justice and the Teen Titans."),
    ("Natasha", "Irons",
     "Natasha Irons was the niece of John Henry Irons. A young technological genius, she followed in the footsteps of her uncle and became the next Steel, using highly-advanced armor she developed.");

/*FULL TABLE DATA */
INSERT INTO Alias(name, DC_CHARACTER_id, notes)
VALUES
    ("Matches Malone",
    (SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne"),
    "Bruce Wayne's undercover criminal persona"),
    ("Kory Anders",
    (SELECT id FROM DC_Character WHERE first_name = "Koriand'r"),
    "The name of Koriand'r human persona"),
    ("Conner Kent",
    (SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"),
    "The name of Kon-El's human persona");

/*MANTLE TABLE DATA */

INSERT INTO Mantle (name, description)
VALUES
    ("Batman", "Costumed as a bat he preys on the fears of criminals, and utilizing a high-tech arsenal"),
    ("Robin", "The patron saint of superhero sidekicks, several young people have taken on the role of Robin, Batman's partner in the battle against crime"),
    ("Nightwing", "Protector of Bludhaven"),
    ("Starfire", ""),
    ("Jericho", ""),
    ("Superboy", ""),
    ("Steel", ""),
    ("Spoiler", "");

/*HAS_MANTLE TABLE DATA */

INSERT INTO Has_Mantle(MANTLE_id, DC_CHARACTER_id, note, current)
VALUES
    ((SELECT id FROM Mantle WHERE name = "Batman"),
     (SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne"),
    "Bruce Wayne was the first Batman", 1),
    ((SELECT id FROM Mantle WHERE name = "Batman"),
    (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
    "Dick Grayson took over the role after the events of Battle for the Cowl", 0),
    ((SELECT id FROM Mantle WHERE name = "Robin"),
    (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
    "Dick Grayson was the first Robin", 0),
    ((SELECT id FROM Mantle WHERE name = "Robin"),
    (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake"),
    "Tim Drake was the third Robin after the death of the second Robin: Jason Todd. He took over the role again after the death of the fourth Robin: Stephanie Brown, and is currently Robin alongside the fifth Robin: Damian Wayne", 1),
    ((SELECT id FROM Mantle WHERE name = "Robin"),
    (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown"),
    "Stephanie Brown was the fourth Robin", 0),
    ((SELECT id FROM Mantle WHERE name = "Starfire"),
    (SELECT id FROM DC_Character WHERE first_name = "Koriand'r"),
    "Kory's superhero name", 1),
    ((SELECT id FROM Mantle WHERE name = "Jericho"),
    (SELECT id FROM DC_Character WHERE first_name = "Joey" AND last_name = "Wilson"),
    "Joey's superhero name", 1),
    ((SELECT id FROM Mantle WHERE name = "Nightwing"),
    (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
    "Dick Grayson took on the name Nightwing after he outgrew Robin", 1),
    ((SELECT id FROM Mantle WHERE name = "Superboy"),
    (SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"),
    "Kon was the second Superboy after Clark Kent", 1),
    ((SELECT id FROM Mantle WHERE name = "Steel"),
    (SELECT id FROM DC_Character WHERE first_name = "Natasha" AND last_name = "Irons"),
    "Nat was the second Steel after her uncle John Henry Irons", 1),
    ((SELECT id FROM Mantle WHERE name = "Spoiler"),
    (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown"),
    "Stephanie Brown's first vigilante persona", 0);


/*TEAM TABLE DATA */

INSERT INTO Team(name, description)
VALUES
    ("Bat-Family", "Gotham based vigilantes that work in close association with Batman"),
    ("Super-Family", "Metropolis based superheroes that work in close association with Superman"),
    ("Teen Titans", "The Teen Titans is a team of young heroes who joined together to fight crime."),
    ("Young Justice", "The Young Justice is a team of young super-heroes and side-kicks who fight crime separately from their adult counterparts.");

/*IN_TEAM TABLE DATA */

INSERT INTO In_Team(TEAM_id, DC_CHARACTER_id, note, current)
VALUES
    ((SELECT id FROM Team WHERE name = "Bat-Family"),
    (SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne"),
    "Bruce Wayne is the leader of the Bat-Family", 1),
    ((SELECT id FROM Team WHERE name = "Bat-Family"),
    (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
    "Dick is one of the main members of the Bat-Family", 1),
    ((SELECT id FROM Team WHERE name = "Bat-Family"),
    (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake"),
    "Tim is one of the main members of the Bat-Family", 1),
    ((SELECT id FROM Team WHERE name = "Bat-Family"),
    (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown"),
    "Though Batman might disagree, Steph considers herself a member of the Bat-Family", 1),
    ((SELECT id FROM Team WHERE name = "Young Justice"),
    (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake"),
    "Tim is one of the founding members of the Young Justice", 1),
    ((SELECT id FROM Team WHERE name = "Young Justice"),
    (SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"),
    "Kon is one of the founding members of the Young Justice", 1),
    ((SELECT id FROM Team WHERE name = "Young Justice"),
    (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown"),
    "Stephanie became an official member of the Young Justice in the 2019 incarnation, she has since quit the team", 0),
    ((SELECT id FROM Team WHERE name = "Super-Family"),
    (SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"),
    "Kon is one of the main members of the Super-Family", 1),
    ((SELECT id FROM Team WHERE name = "Super-Family"),
    (SELECT id FROM DC_Character WHERE first_name = "Natasha" AND last_name = "Irons"),
    "Natasha is currently one of the main members of the Super-Family", 1),
    ((SELECT id FROM Team WHERE name = "Teen Titans"),
    (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
    "Dick is one of the founding members of the Teen Titans", 0),
    ((SELECT id FROM Team WHERE name = "Teen Titans"),
    (SELECT id FROM DC_Character WHERE first_name = "Joey" AND last_name = "Wilson"),
    "Joey joined the Teen Titans in the 1984 New Titans relaunch", 0),
    ((SELECT id FROM Team WHERE name = "Teen Titans"),
    (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake"),
    "Tim joined the Teen Titans after the Young Justice disbanded in the 2003 incarnation of the team", 0),
    ((SELECT id FROM Team WHERE name = "Teen Titans"),
    (SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"),
    "Kon joined the Teen Titans after the Young Justice disbanded in the 2003 incarnation of the team", 0),
    ((SELECT id FROM Team WHERE name = "Teen Titans"),
    (SELECT id FROM DC_Character WHERE first_name = "Koriand'r"),
    "Kory joined the Teen Titans in the 1980s New Titans version of the team", 0);
    
    /*RELATIONSHIP_TYPE TABLE DATA */

    INSERT INTO Relationship_Type(type, description)
    VALUES 
        ("Family", "Two characters are either biologically or legally related"),
        ("Friendship", "At least one character feels some level of platonic attachment to another"),
        ("Romance", "At least one character has romantic or sexual feelings for another"),
        ("Mentorship", "One of the chracters has acted as a teacher to the other"),
        ("Antagonism", "At least one character dislikes or actively opposes the other");
    
    /*RELATIONSHIP TABLE DATA */

    INSERT INTO Relationship(DC_CHARACTER_id_1, DC_CHARACTER_id_2, RELATIONSHIP_TYPE_id, current, note)
    VALUES
        ((SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne"),
        (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
        (SELECT id FROM Relationship_Type WHERE type = "Family"),
        1, "Dick became Bruce's legal ward after his parents died, he later got officially adopted by Bruce"),
        ((SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne"),
        (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
        (SELECT id FROM Relationship_Type WHERE type = "Mentorship"),
        1, "As Robin Dick trained under the tutelage of Batman"),
        ((SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne"),
        (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake"),
        (SELECT id FROM Relationship_Type WHERE type = "Mentorship"),
        1, "As Robin Tim trained under the tutelage of Batman"),
        ((SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne"),
        (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown"),
        (SELECT id FROM Relationship_Type WHERE type = "Mentorship"),
        1, "As Spoiler and later as Robin Steph trained under the tutelage of Batman"),
        ((SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne"),
        (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown"),
        (SELECT id FROM Relationship_Type WHERE type = "Antagonism"),
        0, "Bruce and Steph clash often due to Bruce's dismissive attitude and Steph's recklessness. She was briefly directly working against Batman."),
        ((SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne"),
        (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake"),
        (SELECT id FROM Relationship_Type WHERE type = "Family"),
        1, "After the death of his father, Tim was adopted by Bruce"),
        ((SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
        (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake"),
        (SELECT id FROM Relationship_Type WHERE type = "Family"),
        1, "Dick and Tim became adopted brothers"),
        ((SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
        (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake"),
        (SELECT id FROM Relationship_Type WHERE type = "Mentorship"),
        1, "Dick took on a mentor role for Tim when he beacem the new Robin"),
        ((SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown"),
        (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake"),
        (SELECT id FROM Relationship_Type WHERE type = "Romance"),
        0, "Tim and Steph have been in an on-again-off-again romantic relationship since they were 14"),
        ((SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown"),
        (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake"),
        (SELECT id FROM Relationship_Type WHERE type = "Friendship"),
        1, "After their most recent break up the two remained good friends"),
        ((SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"),
        (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake"),
        (SELECT id FROM Relationship_Type WHERE type = "Friendship"),
        1, "Despite a rocky start to their relationship, Tim and Kon have been best friends since they joined the Young Justice"),
        ((SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"),
        (SELECT id FROM DC_Character WHERE first_name = "Natasha" AND last_name = "Irons"),
        (SELECT id FROM Relationship_Type WHERE type = "Friendship"),
        1, "The two briefly dated but are now good friends"),
        ((SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"),
        (SELECT id FROM DC_Character WHERE first_name = "Natasha" AND last_name = "Irons"),
        (SELECT id FROM Relationship_Type WHERE type = "Romance"),
        0, "The two briefly dated"),      
        ((SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"),
        (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown"),
        (SELECT id FROM Relationship_Type WHERE type = "Antagonism"),
        0, "Kon disliked Steph for taking Tim's place as Robin"),
        ((SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"),
        (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown"),
        (SELECT id FROM Relationship_Type WHERE type = "Friendship"),
        1, "Kon and Steph became friendly with each other after being teammates in the 2019 Young Justice"),
        ((SELECT id FROM DC_Character WHERE first_name = "Koriand'r"),
        (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
        (SELECT id FROM Relationship_Type WHERE type = "Romance"),
        0, "Dick and Kory became romantically involved in the Teen Titans, and have since been in an on-again-off-again romantic relationship"),
         ((SELECT id FROM DC_Character WHERE first_name = "Koriand'r"),
        (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
        (SELECT id FROM Relationship_Type WHERE type = "Friendship"),
        1, "They are currently friends"),
        ((SELECT id FROM DC_Character WHERE first_name = "Joey" AND last_name = "Wilson"),
        (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
        (SELECT id FROM Relationship_Type WHERE type = "Friendship"),
        0, "Dick and Joey became good friends during their time in the Teen Titans");


     /*DC_CHARACTER_TAG TABLE DATA */

     INSERT INTO DC_Character_Tag(TAG_id, DC_Character_id)
     VALUES 
        ((SELECT id FROM Tag WHERE name = "First Appearance"),
        (SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne")),
        ((SELECT id FROM Tag WHERE name = "Reintroduction"),
        (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown")),
        ((SELECT id FROM Tag WHERE name = "Reintroduction"),
        (SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"));

/*TEAM TAG TABLE DATA */
    INSERT INTO Team_Tag(TAG_id, TEAM_id)
    VALUES 
    ((SELECT id FROM Tag WHERE name = "Team Event"),
    (SELECT id FROM Team WHERE name = "Young Justice"));

/*RELATIONSHIP_TAG TABLE DATA */
    INSERT INTO Relationship_Tag(TAG_id, RELATIONSHIP_id)
    VALUES 
    ((SELECT id FROM Tag WHERE name = "Relationship Event"),
    (SELECT id FROM Relationship
    WHERE DC_CHARACTER_id_1 = (SELECT DISTINCT dc_character.id FROM (Relationship
        INNER JOIN DC_Character ON DC_CHARACTER_id_1 = DC_Character.id)
        WHERE DC_Character.first_name = "Koriand'r")
    AND DC_CHARACTER_id_2 = (SELECT DISTINCT dc_character.id FROM (Relationship
        INNER JOIN DC_Character ON DC_CHARACTER_id_2 = DC_Character.id)
        WHERE DC_Character.first_name = "Dick")
    AND RELATIONSHIP_TYPE_id = (SELECT DISTINCT relationship_type.id FROM (relationship 
    INNER JOIN relationship_type ON relationship_type_id = relationship_type.id)
        WHERE relationship_type.type = "Romance"))),
    ((SELECT id FROM Tag WHERE name = "Relationship Event"),
    (SELECT id FROM Relationship
    WHERE DC_CHARACTER_id_1 = (SELECT DISTINCT dc_character.id FROM (Relationship
        INNER JOIN DC_Character ON DC_CHARACTER_id_1 = DC_Character.id)
        WHERE DC_Character.first_name = "Kon")
    AND DC_CHARACTER_id_2 = (SELECT DISTINCT dc_character.id FROM (Relationship
        INNER JOIN DC_Character ON DC_CHARACTER_id_2 = DC_Character.id)
        WHERE DC_Character.first_name = "Tim")
    AND RELATIONSHIP_TYPE_id = (SELECT DISTINCT relationship_type.id FROM (relationship 
    INNER JOIN relationship_type ON relationship_type_id = relationship_type.id)
        WHERE relationship_type.type = "Friendship")));


/*FEATURES TABLE DATA */

INSERT INTO Features(STORY_id, DC_CHARACTER_id, Has_Mantle_id, IN_TEAM_id)
VALUES
    (
        (SELECT id FROM Story WHERE title = "The Case of the Chemical Syndicate"),
        (SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne"),
        (SELECT Has_Mantle.id FROM ((Has_Mantle 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Mantle ON MANTLE_id = Mantle.id)
        WHERE DC_Character.first_name = "Bruce"
        AND DC_Character.last_name = "Wayne"
        AND Mantle.name = "Batman"),
        ""
    ),
    (
        (SELECT id FROM Story WHERE title = "The Night Before"),
        (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson"),
        (SELECT Has_Mantle.id FROM ((Has_Mantle 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Mantle ON MANTLE_id = Mantle.id)
        WHERE DC_Character.first_name = "Dick"
        AND DC_Character.last_name = "Grayson"
        AND Mantle.name = "Nightwing"), 
        (SELECT In_Team.id FROM ((In_Team 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Team ON TEAM_id = Team.id)
        WHERE DC_Character.first_name = "Dick"
        AND DC_Character.last_name = "Grayson"
        AND Team.name = "Teen Titans")
    ),
    (
        (SELECT id FROM Story WHERE title = "The Night Before"),
        (SELECT id FROM DC_Character WHERE first_name = "Koriand'r"),
        (SELECT Has_Mantle.id FROM ((Has_Mantle 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Mantle ON MANTLE_id = Mantle.id)
        WHERE DC_Character.first_name = "Koriand'r"
        AND Mantle.name = "Starfire"),
        (SELECT In_Team.id FROM ((In_Team 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Team ON TEAM_id = Team.id)
        WHERE DC_Character.first_name = "Koriand'r"
        AND Team.name = "Teen Titans")
    ),
    (
        (SELECT id FROM Story WHERE title = "The Night Before"),
        (SELECT id FROM DC_Character WHERE first_name = "Joey" AND last_name = "Wilson"),
        (SELECT Has_Mantle.id FROM ((Has_Mantle 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Mantle ON MANTLE_id = Mantle.id)
        WHERE DC_Character.first_name = "Joey"
        AND DC_Character.last_name = "Wilson"
        AND Mantle.name = "Jericho"),
        (SELECT In_Team.id FROM ((In_Team 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Team ON TEAM_id = Team.id)
        WHERE DC_Character.first_name = "Joey"
        AND DC_Character.last_name = "Wilson"
        AND Team.name = "Teen Titans")
    ),
    (
        (SELECT id FROM Story WHERE title = "Batman Eternal #3"),
        (SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne"),
        (SELECT Has_Mantle.id FROM ((Has_Mantle 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Mantle ON MANTLE_id = Mantle.id)
        WHERE DC_Character.first_name = "Bruce"
        AND DC_Character.last_name = "Wayne"
        AND Mantle.name = "Batman"),
        ""
    ),
    (
        (SELECT id FROM Story WHERE title = "Batman Eternal #3"),
        (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown"),
        "", ""
    ),
    (
        (SELECT id FROM Story WHERE title = "Seven Crises, Part 1"),
        (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake"),
        (SELECT Has_Mantle.id FROM ((Has_Mantle 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Mantle ON MANTLE_id = Mantle.id)
        WHERE DC_Character.first_name = "Tim"
        AND DC_Character.last_name = "Drake"
        AND Mantle.name = "Robin"),
        (SELECT In_Team.id FROM ((In_Team 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Team ON TEAM_id = Team.id)
        WHERE DC_Character.first_name = "Tim"
        AND DC_Character.last_name = "Drake"
        AND Team.name = "Young Justice")
    ),
    (
        (SELECT id FROM Story WHERE title = "Seven Crises, Part 1"),
        (SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"),
        (SELECT Has_Mantle.id FROM ((Has_Mantle 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Mantle ON MANTLE_id = Mantle.id)
        WHERE DC_Character.first_name = "Kon"
        AND DC_Character.last_name = "El"
        AND Mantle.name = "Superboy"),
        (SELECT In_Team.id FROM ((In_Team 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Team ON TEAM_id = Team.id)
        WHERE DC_Character.first_name = "Kon"
        AND DC_Character.last_name = "El"
        AND Team.name = "Young Justice")
    ),
    (
        (SELECT id FROM Story WHERE title = "Chapter 1: City of Tomorrow"),
        (SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El"),
        (SELECT Has_Mantle.id FROM ((Has_Mantle 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Mantle ON MANTLE_id = Mantle.id)
        WHERE DC_Character.first_name = "Kon"
        AND DC_Character.last_name = "El"
        AND Mantle.name = "Superboy"),
        (SELECT In_Team.id FROM ((In_Team 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Team ON TEAM_id = Team.id)
        WHERE DC_Character.first_name = "Kon"
        AND DC_Character.last_name = "El"
        AND Team.name = "Super-Family")
    ),
    (
        (SELECT id FROM Story WHERE title = "Chapter 1: City of Tomorrow"),
        (SELECT id FROM DC_Character WHERE first_name = "Natasha" AND last_name = "Irons"),
        (SELECT Has_Mantle.id FROM ((Has_Mantle 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Mantle ON MANTLE_id = Mantle.id)
        WHERE DC_Character.first_name = "Natasha"
        AND DC_Character.last_name = "Irons"
        AND Mantle.name = "Steel"),
        (SELECT In_Team.id FROM ((In_Team 
        INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
        INNER JOIN Team ON TEAM_id = Team.id)
        WHERE DC_Character.first_name = "Natasha"
        AND DC_Character.last_name = "Irons"
        AND Team.name = "Super-Family")
    );


/*HAS_TAG TABLE DATA */
INSERT INTO Has_Tag(ISSUE_id, TAG_id, DC_Character_Tag_id, Team_Tag_id, Relationship_Tag_id, note)
VALUES
(
    (SELECT Issue.id FROM (Issue
INNER JOIN Series ON SERIES_id = Series.id)
WHERE Series.title = "Detective Comics"
AND Issue.number = "27"),
(SELECT id FROM Tag WHERE name = "First Appearance"), 
(SELECT DC_Character_Tag.id FROM ((DC_Character_Tag 
INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
INNER JOIN Tag ON TAG_id = Tag.id)
WHERE DC_Character.first_name = "Bruce" 
AND DC_Character.last_name = "Wayne"
AND Tag.name = "First Appearance"),
"", 
"", 
""),
(
    (SELECT Issue.id FROM (Issue
INNER JOIN Series ON SERIES_id = Series.id)
WHERE Series.title = "The New Teen Titans"
AND Issue.number = "16"),
(SELECT id FROM Tag WHERE name = "Relationship Event"), 
"",
"",
 (SELECT Relationship_Tag.id FROM (Relationship_Tag
INNER JOIN Relationship ON RELATIONSHIP_id = Relationship.id)
WHERE DC_CHARACTER_id_1 = (SELECT DISTINCT dc_character.id FROM (Relationship
INNER JOIN DC_Character ON DC_CHARACTER_id_1 = DC_Character.id)
WHERE DC_Character.first_name = "Koriand'r")
AND DC_CHARACTER_id_2 = (SELECT DISTINCT dc_character.id FROM (Relationship
INNER JOIN DC_Character ON DC_CHARACTER_id_2 = DC_Character.id)
WHERE DC_Character.first_name = "Dick")
AND RELATIONSHIP_TYPE_id = (SELECT DISTINCT relationship_type.id FROM (relationship 
INNER JOIN relationship_type ON relationship_type_id = relationship_type.id)
WHERE relationship_type.type = "Romance")), 
"Kory is revealed to be in an arragend marriage to someone else"),

(
    (SELECT Issue.id FROM (Issue
INNER JOIN Series ON SERIES_id = Series.id)
WHERE Series.title = "Batman Eternal"
AND Issue.number = "3"),
(SELECT id FROM Tag WHERE name = "Reintroduction"), 
(SELECT DC_Character_Tag.id FROM ((DC_Character_Tag 
INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
INNER JOIN Tag ON TAG_id = Tag.id)
WHERE DC_Character.first_name = "Stephanie" 
AND DC_Character.last_name = "Brown"
AND Tag.name = "Reintroduction"),
"", "", ""),

(
    (SELECT Issue.id FROM (Issue
INNER JOIN Series ON SERIES_id = Series.id)
WHERE Series.title = "Young Justice"
AND Issue.number = "1"),
(SELECT id FROM Tag WHERE name = "Reintroduction"), 
(SELECT DC_Character_Tag.id FROM ((DC_Character_Tag 
INNER JOIN DC_Character ON DC_CHARACTER_id = DC_Character.id)
INNER JOIN Tag ON TAG_id = Tag.id)
WHERE DC_Character.first_name = "Kon" 
AND DC_Character.last_name = "El"
AND Tag.name = "Reintroduction"),
"", "", ""),

(
    (SELECT Issue.id FROM (Issue
INNER JOIN Series ON SERIES_id = Series.id)
WHERE Series.title = "Young Justice"
AND Issue.number = "1"), 
(SELECT id FROM Tag WHERE name = "Team Event"),
"",
(SELECT Team_Tag.id FROM ((Team_Tag
INNER JOIN Tag ON Tag_id = Tag.id)
INNER JOIN Team ON TEAM_id = Team.id)
WHERE Tag.name = "Team Event"
AND Team.name = "Young Justice"),
"", "The Team reforms with a new line up"),

(
    (SELECT Issue.id FROM (Issue
INNER JOIN Series ON SERIES_id = Series.id)
WHERE Series.title = "Young Justice"
AND Issue.number = "1"),
(SELECT id FROM Tag WHERE name = "Relationship Event"), 
"",
"",
 (SELECT Relationship_Tag.id FROM (Relationship_Tag
INNER JOIN Relationship ON RELATIONSHIP_id = Relationship.id)
WHERE DC_CHARACTER_id_1 = (SELECT DISTINCT dc_character.id FROM (Relationship
INNER JOIN DC_Character ON DC_CHARACTER_id_1 = DC_Character.id)
WHERE DC_Character.first_name = "Kon")
AND DC_CHARACTER_id_2 = (SELECT DISTINCT dc_character.id FROM (Relationship
INNER JOIN DC_Character ON DC_CHARACTER_id_2 = DC_Character.id)
WHERE DC_Character.first_name = "Tim")
AND RELATIONSHIP_TYPE_id = (SELECT DISTINCT relationship_type.id FROM (relationship 
INNER JOIN relationship_type ON relationship_type_id = relationship_type.id)
WHERE relationship_type.type = "Friendship")), 
"Tim and Kon are reunited");

/*SOURCE TABLE DATA */
INSERT INTO Source(name, description, link)
VALUES  
     ("Comic Book Reading Orders", 
    "The goal of this site is to be the most extensive resource for comic book reading orders on the internet.  We provide reading orders for characters and events from Marvel,  DC,  and other publishers.  Looking at the enormous number of comics that have come out in the last 70+ years and not knowing where to start can be daunting.  We hope with the orders provided on this site that we can make your comic reading experience easy and enjoyable.",
    "https://comicbookreadingorders.com/"),
    ("Comic Book Herald",
    "Comic Book Herald is a site dedicated to guiding enthusiastic comic book readers through the immense amounts of Marvel and DC books and trade paperbacks available.",
    "https://www.comicbookherald.com/"),
    ("Comic Book Treasury",
    "Welcome to Comic Book Treasury, a blog dedicated to comics reading order for Marvel, DC and other publishers. We cover major characters and other favorites as well as events, and more!",
    "https://www.comicbooktreasury.com/");  

/*READING_ORDER TABLE DATA */
INSERT INTO Reading_Order(SOURCE_id, name, type, link)
VALUES 
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Pre-Crisis: CBRO", "Continuity", "https://comicbookreadingorders.com/dc/dc-master-reading-order-part-1/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Post-Crisis: CBRO", "Continuity", "https://comicbookreadingorders.com/dc/dc-master-reading-order-part-2/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "New 52: CBRO", "Continuity", "https://comicbookreadingorders.com/dc/events/new-52-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Rebirth: CBRO", "Continuity", "https://comicbookreadingorders.com/dc/events/new-52-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Infinite Frontier and Beyond: CBRO", "Continuity", "https://comicbookreadingorders.com/dc/events/new-52-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Pre-Crisis: CBH", "Continuity", "https://www.comicbookherald.com/the-best-40-dc-comics-from-1942-to-2000/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Post-Crisis: CBH", "Continuity", "https://www.comicbookherald.com/the-modern-dc-universe-in-25-trade-collections-2000-to-2011-fast-track/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "New 52: CBH", "Continuity", "https://www.comicbookherald.com/question-of-the-week-do-you-have-a-dc-new-52-fast-track-guide/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Rebirth: CBH", "Continuity", "https://www.comicbookherald.com/question-of-the-week-do-you-have-a-dc-rebirth-fast-track-guide/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Infinite Frontier and Beyond: CBH", "Continuity", "https://www.comicbookherald.com/question-of-the-week-do-you-have-a-dc-rebirth-fast-track-guide/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Pre-Crisis: CBT", "Continuity", "https://www.comicbooktreasury.com/crisis-dc-comics-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Post-Crisis: CBT", "Continuity", "https://www.comicbooktreasury.com/crisis-dc-comics-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "New 52: CBT", "Continuity", "https://www.comicbooktreasury.com/crisis-dc-comics-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Rebirth: CBT", "Continuity", "https://www.comicbooktreasury.com/crisis-dc-comics-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Infinite Frontier and Beyond: CBT", "Continuity", "https://www.comicbooktreasury.com/crisis-dc-comics-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Bruce Wayne: CBRO", "Character", "https://comicbookreadingorders.com/dc/characters/batman-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Stephanie Brown: CBRO", "Character", "https://comicbookreadingorders.com/dc/characters/stephanie-brown-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Dick Grayson: CBRO", "Character", "https://comicbookreadingorders.com/dc/characters/dick-grayson-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Tim Drake: CBRO", "Character", "https://comicbookreadingorders.com/dc/characters/tim-drake-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Bruce Wayne: CBH", "Character", "https://www.comicbookherald.com/reading-dc-comics/batman-reading-order/"

),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Stephanie Brown: CBH", "Character", "https://www.comicbookherald.com/batgirl-reading-order/"

),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Dick Grayson: CBH", "Character", "https://www.comicbookherald.com/nightwing-dick-grayson-first-robin-reading-order/"

),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Tim Drake: CBH", "Character", "https://www.comicbookherald.com/tim-drake-red-robin-reading-order/"

),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Bruce Wayne: CBT", "Character", "https://www.comicbooktreasury.com/batman-reading-order-the-modern-age/"

),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Stephanie Brown: CBT", "Character", "https://www.comicbooktreasury.com/stephanie-brown-reading-order/"

),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Dick Grayson: CBT", "Character", "https://www.comicbooktreasury.com/dick-grayson-robin-reading-order/"

),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Tim Drake: CBT", "Character", "https://www.comicbooktreasury.com/tim-drake-reading-order/"

),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Kon-El: CBT", "Character", "https://www.comicbooktreasury.com/conner-kent-reading-order/"

),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Teen Titans: CBRO", "Team", "https://comicbookreadingorders.com/dc/characters/teen-titans-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Teen Titans: CBH", "Team", "https://www.comicbookherald.com/teen-titans-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Young Justice: CBH", "Team", "https://www.comicbookherald.com/young-justice-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Teen Titans: CBT", "Team", "https://www.comicbooktreasury.com/teen-titans-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Young Justice: CBT", "Team", "https://www.comicbooktreasury.com/young-justice-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Crisis on Infinite Earths: CBRO", "Event", "https://comicbookreadingorders.com/dc/events/crisis-on-infinite-earths-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Flashpoint: CBRO", "Event", "https://comicbookreadingorders.com/dc/events/flashpoint-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Dark Nights Death Metal: CBRO", "Event", "https://comicbookreadingorders.com/dc/events/dark-nights-death-metal-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Reading Orders"),
    "Dark Crisis: CBRO", "Event", "https://comicbookreadingorders.com/dc/events/dark-crisis-on-infinite-earths-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Crisis on Infinite Earths: CBH", "Event", "https://www.comicbookherald.com/reading-dc-comics/crisis-on-infinite-earths-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Flashpoint: CBH", "Event", "https://www.comicbookherald.com/reading-dc-comics/flashpoint-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Dark Nights Death Metal: CBH", "Event", "https://www.comicbookherald.com/reading-dc-comics/dc-rebirth-reading-order/dark-nights-death-metal/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Herald"),
    "Dark Crisis: CBH", "Event", "https://www.comicbookherald.com/reading-dc-comics/dc-infinite-frontier-reading-order/dark-crisis/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Crisis on Infinite Earths: CBT", "Event", "https://www.comicbooktreasury.com/crisis-on-infinite-earths-reading-order-dc-comics/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Flashpoint: CBT", "Event", "https://www.comicbooktreasury.com/flashpoint-reading-order-a-dc-comics-event-geoff-johns-andy-kubert/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Dark Nights Death Metal: CBT", "Event", "https://www.comicbooktreasury.com/dark-nights-death-metal-reading-order/"
),
(
    (SELECT id FROM Source WHERE name = "Comic Book Treasury"),
    "Dark Crisis: CBT", "Event", "https://www.comicbooktreasury.com/dark-crisis-reading-order/"
);

/*CONTINUITY_READING_ORDER TABLE DATA */
INSERT INTO Continuity_Reading_Order
VALUES 
(
    (SELECT id FROM Reading_Order WHERE name = "Pre-Crisis: CBRO"),
    (SELECT id FROM Continuity WHERE name = "Pre-Crisis")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Pre-Crisis: CBH"),
    (SELECT id FROM Continuity WHERE name = "Pre-Crisis")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Pre-Crisis: CBT"),
    (SELECT id FROM Continuity WHERE name = "Pre-Crisis")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Post-Crisis: CBRO"),
    (SELECT id FROM Continuity WHERE name = "Post-Crisis")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Post-Crisis: CBH"),
    (SELECT id FROM Continuity WHERE name = "Post-Crisis")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Post-Crisis: CBT"),
    (SELECT id FROM Continuity WHERE name = "Post-Crisis")
),
(
    (SELECT id FROM Reading_Order WHERE name = "New 52: CBRO"),
    (SELECT id FROM Continuity WHERE name = "New 52")
),
(
    (SELECT id FROM Reading_Order WHERE name = "New 52: CBH"),
    (SELECT id FROM Continuity WHERE name = "New 52")
),
(
    (SELECT id FROM Reading_Order WHERE name = "New 52: CBT"),
    (SELECT id FROM Continuity WHERE name = "New 52")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Rebirth: CBRO"),
    (SELECT id FROM Continuity WHERE name = "Rebirth")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Rebirth: CBH"),
    (SELECT id FROM Continuity WHERE name = "Rebirth")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Rebirth: CBT"),
    (SELECT id FROM Continuity WHERE name = "Rebirth")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Infinite Frontier and Beyond: CBRO"),
    (SELECT id FROM Continuity WHERE name = "Infinite Frontier and Beyond")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Infinite Frontier and Beyond: CBH"),
    (SELECT id FROM Continuity WHERE name = "Infinite Frontier and Beyond")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Infinite Frontier and Beyond: CBT"),
    (SELECT id FROM Continuity WHERE name = "Infinite Frontier and Beyond")
);

/*DC_CHARACTER_READING_ORDER TABLE DATA */
INSERT INTO DC_CHARACTER_Reading_Order
VALUES 
(
    (SELECT id FROM Reading_Order WHERE name = "Bruce Wayne: CBRO"),
    (SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Bruce Wayne: CBH"),
    (SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Bruce Wayne: CBT"),
    (SELECT id FROM DC_Character WHERE first_name = "Bruce" AND last_name = "Wayne")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Stephanie Brown: CBRO"),
    (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Stephanie Brown: CBH"),
    (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Stephanie Brown: CBT"),
    (SELECT id FROM DC_Character WHERE first_name = "Stephanie" AND last_name = "Brown")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Dick Grayson: CBRO"),
    (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Dick Grayson: CBH"),
    (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Dick Grayson: CBT"),
    (SELECT id FROM DC_Character WHERE first_name = "Dick" AND last_name = "Grayson")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Tim Drake: CBRO"),
    (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Tim Drake: CBH"),
    (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Tim Drake: CBT"),
    (SELECT id FROM DC_Character WHERE first_name = "Tim" AND last_name = "Drake")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Kon-El: CBT"),
    (SELECT id FROM DC_Character WHERE first_name = "Kon" AND last_name = "El")
);

/*TEAM_READING_ORDER TABLE DATA */
INSERT INTO Team_Reading_Order
VALUES
(
    (SELECT id FROM Reading_Order WHERE name = "Teen Titans: CBRO"),
    (SELECT id FROM Team WHERE name = "Teen Titans")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Teen Titans: CBH"),
    (SELECT id FROM Team WHERE name = "Teen Titans")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Teen Titans: CBT"),
    (SELECT id FROM Team WHERE name = "Teen Titans")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Young Justice: CBH"),
    (SELECT id FROM Team WHERE name = "Young Justice")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Young Justice: CBT"),
    (SELECT id FROM Team WHERE name = "Young Justice")
);

/*CROSSOVER_EVENT_READING_ORDER TABLE DATA */
INSERT INTO Crossover_Event_Reading_Order
VALUES
(
    (SELECT id FROM Reading_Order WHERE name = "Crisis on Infinite Earths: CBRO"),
    (SELECT id FROM Crossover_Event WHERE name = "Crisis on Infinite Earths")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Crisis on Infinite Earths: CBH"),
    (SELECT id FROM Crossover_Event WHERE name = "Crisis on Infinite Earths")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Crisis on Infinite Earths: CBT"),
    (SELECT id FROM Crossover_Event WHERE name = "Crisis on Infinite Earths")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Flashpoint: CBRO"),
    (SELECT id FROM Crossover_Event WHERE name = "Flashpoint")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Flashpoint: CBH"),
    (SELECT id FROM Crossover_Event WHERE name = "Flashpoint")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Flashpoint: CBT"),
    (SELECT id FROM Crossover_Event WHERE name = "Flashpoint")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Dark Nights Death Metal: CBRO"),
    (SELECT id FROM Crossover_Event WHERE name = "Dark Nights: Death Metal")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Dark Nights Death Metal: CBH"),
    (SELECT id FROM Crossover_Event WHERE name = "Dark Nights: Death Metal")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Dark Nights Death Metal: CBT"),
    (SELECT id FROM Crossover_Event WHERE name = "Dark Nights: Death Metal")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Dark Crisis: CBRO"),
    (SELECT id FROM Crossover_Event WHERE name = "Dark Crisis")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Dark Crisis: CBH"),
    (SELECT id FROM Crossover_Event WHERE name = "Dark Crisis")
),
(
    (SELECT id FROM Reading_Order WHERE name = "Dark Crisis: CBT"),
    (SELECT id FROM Crossover_Event WHERE name = "Dark Crisis")
);

/*IN_READING_ORDER TABLE DATA */
INSERT INTO In_Reading_Order(READING_ORDER_id, ISSUE_id, position)
VALUES
(
    (SELECT id FROM READING_ORDER WHERE name = "Pre-Crisis: CBRO"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Detective Comics" AND number = "27"),
    3
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Bruce Wayne: CBRO"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Detective Comics"
    AND publication_year = "1937"
    AND number = "27"),
    1
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Bruce Wayne: CBH"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Detective Comics" 
    AND publication_year = "1937"
    AND number = "27"),
    1
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Post-Crisis: CBT"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "The New Teen Titans" AND 
    publication_year = "1984"
    AND number = "16"),
    50
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Dick Grayson: CBT"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "The New Teen Titans" AND 
    publication_year = "1984"
    AND number = "16"),
    110
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Teen Titans: CBT"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "The New Teen Titans" AND 
    publication_year = "1984"
    AND number = "16"),
    55
),
(
    (SELECT id FROM READING_ORDER WHERE name = "New 52: CBRO"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Batman Eternal" AND 
    publication_year = "2014"
    AND number = "3"),
    375
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Bruce Wayne: CBRO"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Batman Eternal" AND 
    publication_year = "2014"
    AND number = "3"),
    375
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Stephanie Brown: CBRO"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Batman Eternal" AND 
    publication_year = "2014"
    AND number = "3"),
    55
),
(
    (SELECT id FROM READING_ORDER WHERE name = "New 52: CBH"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Batman Eternal" AND 
    publication_year = "2014"
    AND number = "3"),
    375
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Bruce Wayne: CBH"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Batman Eternal" AND 
    publication_year = "2014"
    AND number = "3"),
    375
),
(
    (SELECT id FROM READING_ORDER WHERE name = "New 52: CBT"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Batman Eternal" AND 
    publication_year = "2014"
    AND number = "3"),
    375
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Bruce Wayne: CBT"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Batman Eternal" AND 
    publication_year = "2014"
    AND number = "3"),
    375
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Stephanie Brown: CBT"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Batman Eternal" AND 
    publication_year = "2014"
    AND number = "3"),
    55
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Tim Drake: CBT"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Batman Eternal" AND 
    publication_year = "2014"
    AND number = "3"),
    155
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Rebirth: CBRO"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Young Justice" AND 
    publication_year = "2019"
    AND number = "1"),
    455
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Rebirth: CBRO"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Young Justice" AND 
    publication_year = "2019"
    AND number = "1"),
    155
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Young Justice: CBH"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Young Justice" AND 
    publication_year = "2019"
    AND number = "1"),
    65
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Tim Drake: CBT"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Young Justice" AND 
    publication_year = "2019"
    AND number = "1"),
    465
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Kon-El: CBT"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Young Justice" AND 
    publication_year = "2019"
    AND number = "1"),
    265
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Young Justice: CBT"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Young Justice" AND 
    publication_year = "2019"
    AND number = "1"),
    65
),
(
    (SELECT id FROM READING_ORDER WHERE name = "Infinite Frontier and Beyond: CBH"),
    (SELECT Issue.id FROM (Issue
    INNER JOIN Series on SERIES_id = Series.id)
    WHERE title = "Steelworks" AND 
    publication_year = "2023"
    AND number = "1"),
    185
);
