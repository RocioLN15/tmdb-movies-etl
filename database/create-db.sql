BEGIN TRY
    BEGIN TRANSACTION;

	-- MOVIES --
	CREATE TABLE movies
	(
		id INT NOT NULL,
		title VARCHAR(80) NOT NULL,
		runtime SMALLINT,
		country VARCHAR(2),
		release_date DATE,
		budget BIGINT,
		revenue BIGINT,
		vote_average NUMERIC(5, 3),
		vote_count INT
	)

	ALTER TABLE movies
		ADD CONSTRAINT pk_movie PRIMARY KEY ( id );

	---

	-- GENRES --
	CREATE TABLE genres
	(
		id INT NOT NULL,
		genre VARCHAR(20) NOT NULL
	)

	ALTER TABLE genres
		ADD CONSTRAINT pk_genre PRIMARY KEY ( id );

	---

	-- GENDERS --
	CREATE TABLE genders
	(
		id INT IDENTITY(1, 1),
		code VARCHAR(2) UNIQUE NOT NULL,
		[full] VARCHAR(12) NOT NULL
	)

	ALTER TABLE genders
		ADD CONSTRAINT pk_gender PRIMARY KEY ( id );

	INSERT INTO genders (code, [full]) VALUES
		('F', 'Female'),
		('M', 'Male'),
		('U', 'Undefined');

	---

	-- ACTORS --
	CREATE TABLE actors
	(
		id INT NOT NULL,
		name VARCHAR(70) NOT NULL,
		original_name NVARCHAR(70),
		gender_id INT
	)

	ALTER TABLE actors
		ADD CONSTRAINT pk_actor PRIMARY KEY ( id );

	ALTER TABLE actors
		ADD CONSTRAINT fk_actor_gender FOREIGN KEY ( gender_id )
		REFERENCES genders ( id );

	---

	-- DIRECTORS --
	CREATE TABLE directors
	(
		id INT NOT NULL,
		name VARCHAR(70) NOT NULL,
		original_name NVARCHAR(70),
		gender_id INT
	)

	ALTER TABLE directors
		ADD CONSTRAINT pk_director PRIMARY KEY ( id );

	ALTER TABLE directors
		ADD CONSTRAINT fk_director_gender FOREIGN KEY ( gender_id )
		REFERENCES genders ( id );

	---

	-- CHARACTERS --
	CREATE TABLE characters
	(
		id INT IDENTITY(1, 1),
		name VARCHAR(70) NOT NULL,
		movie_id INT,
		actor_id INT
	)

	ALTER TABLE characters
		ADD CONSTRAINT pk_character PRIMARY KEY ( id );

	ALTER TABLE characters
		ADD CONSTRAINT fk_character_movie FOREIGN KEY ( movie_id )
		REFERENCES movies ( id );

	ALTER TABLE characters
		ADD CONSTRAINT fk_character_actor FOREIGN KEY ( actor_id )
		REFERENCES actors ( id );

	---

	-- MOVIES_GENRES --
	CREATE TABLE movies_genres
	(
		movie_id INT NOT NULL,
		genre_id INT NOT NULL
	)

	ALTER TABLE movies_genres
		ADD CONSTRAINT pk_movie_genre PRIMARY KEY ( movie_id, genre_id );

	ALTER TABLE movies_genres
		ADD CONSTRAINT fk_m_g_movie FOREIGN KEY ( movie_id )
		REFERENCES movies ( id );

	ALTER TABLE movies_genres
		ADD CONSTRAINT fk_m_g_genre FOREIGN KEY ( genre_id )
		REFERENCES genres ( id );

	---

	-- MOVIES_DIRECTORS --
	CREATE TABLE movies_directors
	(
		movie_id INT NOT NULL,
		director_id INT NOT NULL
	)

	ALTER TABLE movies_directors
		ADD CONSTRAINT pk_movie_director PRIMARY KEY ( movie_id, director_id );

	ALTER TABLE movies_directors
		ADD CONSTRAINT fk_m_d_movie FOREIGN KEY ( movie_id )
		REFERENCES movies ( id );

	ALTER TABLE movies_directors
		ADD CONSTRAINT fk_m_d_director FOREIGN KEY ( director_id )
		REFERENCES directors ( id );

	---

	COMMIT TRANSACTION;
	PRINT 'All the tables have been created';

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
	END;

	THROW;
END CATCH;